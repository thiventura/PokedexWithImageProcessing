import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';
import 'package:tts/tts.dart';
import 'dart:io';

List<CameraDescription> cameras;
var pokemons;

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    await Tflite.loadModel(
      model: "assets/model/pokemon151CartoonToy3dv2.lite",
      labels: "assets/model/pokemon151CartoonToy3d.txt",
    );
    await Tts.setLanguage('pt-BR');
    loadPokemonList();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: ${e.code}\nError Message: ${e.description}');
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(
        MaterialApp(
          title: 'Pokedex',
          debugShowCheckedModeBanner: false,
          home: Pokedex(),
        )
      );
    });
}

void loadPokemonList() {
  pokemons = {
    'bulbasaur':'001',
    'ivysaur':'002',
    'venusaur':'003',
    'charmander':'004',
    'charmeleon':'005',
    'charizard':'006',
    'squirtle':'007',
    'wartortle':'008',
    'blastoise':'009',
    'caterpie':'010',
    'metapod':'011',
    'butterfree':'012',
    'weedle':'013',
    'kakuna':'014',
    'beedrill':'015',
    'pidgey':'016',
    'pidgeotto':'017',
    'pidgeot':'018',
    'rattata':'019',
    'raticate':'020',
    'spearow':'021',
    'fearow':'022',
    'ekans':'023',
    'arbok':'024',
    'pikachu':'025',
    'raichu':'026',
    'sandshrew':'027',
    'sandslash':'028',
    'nidoran-f':'029',
    'nidorina':'030',
    'nidoqueen':'031',
    'nidoran-m':'032',
    'nidorino':'033',
    'nidoking':'034',
    'clefairy':'035',
    'clefable':'036',
    'vulpix':'037',
    'ninetales':'038',
    'jigglypuff':'039',
    'wigglytuff':'040',
    'zubat':'041',
    'golbat':'042',
    'oddish':'043',
    'gloom':'044',
    'vileplume':'045',
    'paras':'046',
    'parasect':'047',
    'venonat':'048',
    'venomoth':'049',
    'diglett':'050',
    'dugtrio':'051',
    'meowth':'052',
    'persian':'053',
    'psyduck':'054',
    'golduck':'055',
    'mankey':'056',
    'primeape':'057',
    'growlithe':'058',
    'arcanine':'059',
    'poliwag':'060',
    'poliwhirl':'061',
    'poliwrath':'062',
    'abra':'063',
    'kadabra':'064',
    'alakazam':'065',
    'machop':'066',
    'machoke':'067',
    'machamp':'068',
    'bellsprout':'069',
    'weepinbell':'070',
    'victreebel':'071',
    'tentacool':'072',
    'tentacruel':'073',
    'geodude':'074',
    'graveler':'075',
    'golem':'076',
    'ponyta':'077',
    'rapidash':'078',
    'slowpoke':'079',
    'slowbro':'080',
    'magnemite':'081',
    'magneton':'082',
    'farfetchd':'083',
    'doduo':'084',
    'dodrio':'085',
    'seel':'086',
    'dewgong':'087',
    'grimer':'088',
    'muk':'089',
    'shellder':'090',
    'cloyster':'091',
    'gastly':'092',
    'haunter':'093',
    'gengar':'094',
    'onix':'095',
    'drowzee':'096',
    'hypno':'097',
    'krabby':'098',
    'kingler':'099',
    'voltorb':'100',
    'electrode':'101',
    'exeggcute':'102',
    'exeggutor':'103',
    'cubone':'104',
    'marowak':'105',
    'hitmonlee':'106',
    'hitmonchan':'107',
    'lickitung':'108',
    'koffing':'109',
    'weezing':'110',
    'rhyhorn':'111',
    'rhydon':'112',
    'chansey':'113',
    'tangela':'114',
    'kangaskhan':'115',
    'horsea':'116',
    'seadra':'117',
    'goldeen':'118',
    'seaking':'119',
    'staryu':'120',
    'starmie':'121',
    'mr-mime':'122',
    'scyther':'123',
    'jynx':'124',
    'electabuzz':'125',
    'magmar':'126',
    'pinsir':'127',
    'tauros':'128',
    'magikarp':'129',
    'gyarados':'130',
    'lapras':'131',
    'ditto':'132',
    'eevee':'133',
    'vaporeon':'134',
    'jolteon':'135',
    'flareon':'136',
    'porygon':'137',
    'omanyte':'138',
    'omastar':'139',
    'kabuto':'140',
    'kabutops':'141',
    'aerodactyl':'142',
    'snorlax':'143',
    'articuno':'144',
    'zapdos':'145',
    'moltres':'146',
    'dratini':'147',
    'dragonair':'148',
    'dragonite':'149',
    'mewtwo':'150',
    'mew':'151',
    'solgaleo':'152',
    'lunala':'153',
    'greninja':'154',
    'chesnaught':'155',
    'necrozma':'156',
  };
}

class Pokedex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex'),
        backgroundColor: Colors.red,
      ),
      body: CameraScreen(),
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
    controller = CameraController(cameras[0], ResolutionPreset.high);
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
      return CameraPreview(controller);
    }
  }

  /// Display the control bar with buttons to take pictures.
  Widget _captureControlRowWidget() {
    final size = 100.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          height: size,
          width: size,
          child: new IconButton(
              padding: new EdgeInsets.all(0.0),
              color: Colors.red,
              icon: new Icon(Icons.camera_alt, size: size),
              onPressed: controller != null && controller.value.isInitialized 
                ? onTakePictureButtonPressed : null,
          )
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
          detectPokemon().then((_) {});
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

    // Check if file already exist
    final previousImage = File(filePath);
    if (previousImage.existsSync()) {
      // if exist, delete it
      previousImage.delete();
    }

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
    var recognitions = await Tflite.runModelOnImage(
      path: imagePath,
      inputSize: 224,
      numChannels: 3,
      imageMean: 128,
      imageStd: 128,
      numResults: 5,
      threshold: 0.0,
      numThreads: 1,
    );
    print(recognitions);
    var recognition;
    for (recognition in recognitions) {
      if (recognition['index'] == 458) 
        continue;
      break;
    }

    final String pokemonName = recognition["label"].split(" ")[0];
    final String pokemonNumber = pokemons[pokemonName];
    final String pokemonDescription = await rootBundle.loadString('assets/pokemons/descricao/$pokemonNumber.txt');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PokemonScreen(pokemonName: pokemonName, pokemonNumber: pokemonNumber, pokemonDescription: pokemonDescription)),
    );
  }
}

class PokemonScreen extends StatelessWidget {
  PokemonScreen({this.pokemonName, this.pokemonNumber, this.pokemonDescription});
  final String pokemonName;
  final String pokemonNumber;
  final String pokemonDescription;

  @override
  Widget build(BuildContext context) {
    Widget textSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Text(
        pokemonDescription,
        softWrap: true,
      ),
    );

    final sizeIcon = 100.0;
    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          height: sizeIcon,
          width: sizeIcon,
          child: IconButton(
            padding: new EdgeInsets.all(0.0),
            icon: new Icon(Icons.camera_alt, size: sizeIcon),
            color: Colors.red,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        )
      ],
    );

    Tts.speak(pokemonName);
    Tts.speak(pokemonDescription);

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemonName),
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Image.asset(
            'assets/pokemons/imagens/$pokemonNumber.png',
            width: 600.0,
            height: 240.0,
            fit: BoxFit.contain,
          ),
          textSection,
          buttonSection,
        ],
      ),
    );
  }
}