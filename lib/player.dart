import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:projeto/Home_page.dart';
import 'package:projeto/helpers/database_helper.dart';

class Player extends StatefulWidget {
  Player(
      {super.key,
      required this.audioPath,
      required this.musicaPath,
      required this.nomeArquivo,
      required this.jaSalvo});
  String audioPath;
  String musicaPath;
  String nomeArquivo;
  bool jaSalvo;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final dbHelper = DatabaseHelper.instance;
  final audioPlayer1 = AudioPlayer();
  final audioPlayer2 = AudioPlayer();

  bool isPlaying1 = false;
  bool isPlaying2 = false;
  Duration duration1 = Duration.zero;
  Duration position1 = Duration.zero;
  Duration duration2 = Duration.zero;
  Duration position2 = Duration.zero;

  @override
  void dispose() {
    audioPlayer1.dispose();
    audioPlayer2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setAudio();

    audioPlayer1.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying1 = state == PlayerState.PLAYING;
      });
    });
    audioPlayer1.onDurationChanged.listen((newDuration) {
      setState(() {
        duration1 = newDuration;
      });
    });
    audioPlayer1.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position1 = newPosition;
      });
    });
    audioPlayer2.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying2 = state == PlayerState.PLAYING;
      });
    });
    audioPlayer2.onDurationChanged.listen((newDuration) {
      setState(() {
        duration2 = newDuration;
      });
    });
    audioPlayer2.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position2 = newPosition;
      });
    });

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: widget.nomeArquivo.toString(),
      DatabaseHelper.columnAudio: widget.audioPath.toString(),
      DatabaseHelper.columnMusica: widget.musicaPath.toString()
    };

    if (widget.jaSalvo) {
    } else {
      final id = dbHelper.insert(row);
      print('inserted row id: $id');
    }
  }

  Future setAudio() async {
    audioPlayer2.setUrl(widget.audioPath, isLocal: true);
    audioPlayer1.setUrl(widget.musicaPath, isLocal: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ou??a seu som"),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
            icon: Icon(Icons.home_outlined)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            const Text(
              "KARAOQU??",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              "Reproduzir",
              style: TextStyle(fontSize: 20),
            ),
            Slider(
              min: 0,
              max: ((duration1.inSeconds.toDouble())) + 0.5,
              value: position1.inSeconds.toDouble(),
              onChanged: (value) async {
                final position1 = Duration(seconds: value.toInt());
                if (position1 == duration1) {
                  await audioPlayer1.stop();
                }
                await audioPlayer1.seek(position1);
                await audioPlayer1.resume();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position1)),
                  Text(formatTime(duration1)),
                ],
              ),
            ),
            Slider(
              min: 0,
              max: ((duration2.inSeconds.toDouble())) + 0.5,
              value: position2.inSeconds.toDouble(),
              onChanged: (value) async {
                final position2 = Duration(seconds: value.toInt());
                if (position2 == duration2) {
                  await audioPlayer2.stop();
                }
                await audioPlayer2.seek(position2);
                await audioPlayer2.resume();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position2)),
                  Text(formatTime(duration2)),
                ],
              ),
            ),
            CircleAvatar(
              radius: 35,
              child: IconButton(
                icon: Icon(isPlaying1 ? Icons.pause : Icons.play_arrow),
                iconSize: 50,
                onPressed: () async {
                  if (isPlaying1 || isPlaying2) {
                    //se 1 tiver tocando pausa os dois
                    await audioPlayer1.pause();
                    await audioPlayer2.pause();
                  } else if (!isPlaying1 || !isPlaying2) {
                    audioPlayer1.resume();
                    audioPlayer2.resume();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatTime(Duration duration) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    final horas = doisDigitos(duration.inHours);
    final minutos = doisDigitos(duration.inMinutes.remainder(60));
    final segundos = doisDigitos(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) horas,
      minutos,
      segundos,
    ].join(':');
  }
}
