import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';

List<CameraDescription> cameras;

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    cameras = await availableCameras();
    await Tflite.loadModel(
      model: "assets/pokemon25.tflite",
      labels: "assets/pokemon25.txt",
    );
  } on CameraException catch (e) {
    print('Error: ${e.code}\nError Message: ${e.description}');
  }
  runApp(Pokedex());
}

class Pokedex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pokedex'),
        ),
        body: CameraScreen(),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController controller;
  String imagePath;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Future<void> dispose() async {
    controller?.dispose();
    await Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(
                child: _cameraPreviewWidget(),
              ),
            ),
          ),
        ),
        _captureControlRowWidget(),
      ],
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  /// Display the control bar with buttons to take pictures.
  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.red,
          onPressed: controller != null &&
                  controller.value.isInitialized 
              ? onTakePictureButtonPressed
              : null,
        )
      ],
    );
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) {
          detectPokemon().then((_) { 
            
          });
        } 
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }
    
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/pokedex';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/capture.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      print('Wait a second to take another picture');
      return null;
    }

    try {
      print('Taking a picture');
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    return filePath;
  }

  Future<void> detectPokemon() async {
    print(imagePath);
    var recognitions = await Tflite.runModelOnImage(
      path: imagePath,
      inputSize: 299,
      numChannels: 3,
      imageMean: 128.0,
      imageStd: 128.0,
      numResults: 5,
      threshold: 0.1,
      numThreads: 1,
    );
    print(recognitions);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PokemonScreen(pokemon: 'chamander')),
    );
  }
}

class PokemonScreen extends StatelessWidget {
  PokemonScreen({this.pokemon});
  final String pokemon;

  @override
  Widget build(BuildContext context) {
    Widget textSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Text(
        '''
        Bulbasaur pode ser visto a dormir na luz do sol brilhante. Há uma semente nas costas. Ao absorver os raios do sol, a semente cresce progressivamente.
        ''',
        softWrap: true,
      ),
    );

    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.red,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CameraScreen()),
            );
          },
        )
      ],
    );

    return ListView(
      children: [
        Image.asset(
          'assets/pokemons/$pokemon.jpg',
          width: 600.0,
          height: 240.0,
          fit: BoxFit.cover,
        ),
        textSection,
        buttonSection,
      ],
    );
  }
}