## Pokedex with image processing

### Summary
This project creates a [Pokedex](http://pokemon.wikia.com/wiki/Pok%C3%A9dex) which can identify Pokémons from [first generation](https://en.wikipedia.org/wiki/List_of_generation_I_Pok%C3%A9mon). Open this pokedex, take a picture, and you will receive the image and description of the pokémon detected. It also speak the description =)

It was used Flutter for the app development and a Tensorflow model for image classification. If you want to learning something related to this project, I leaved links in the [Wiki](https://github.com/thiventura/PokedexWithImageProcessing/wiki/Home) of this repository.


### Screenshots
![Screenshot of Camera Screen](https://github.com/thiventura/PokedexWithImageProcessing/blob/master/docs/screenshotcamera.png)

![Screenshot of Pokemon Screen](https://github.com/thiventura/PokedexWithImageProcessing/blob/master/docs/screenshotpokemon.png)


### Plugins
To load Tensorflow model and perform image recognition was used the [Tflite](https://pub.dartlang.org/packages/tflite) plugin. [Camera](https://pub.dartlang.org/packages/camera) plugin was used to access camera, display preview and capture snapshots. [TTS](https://pub.dartlang.org/packages/tts) plugin was used to perform Text to Speach with the pokémon's description.


## Acknowledgements
[Christopher Betz](https://github.com/cbetz/flutter-vision)

[Harshit Dwivedi](https://heartbeat.fritz.ai/building-pok%C3%A9dex-in-android-using-tensorflow-lite-and-firebase-cc780848395)
