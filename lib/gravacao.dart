import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projeto/player.dart';
import 'player.dart';
import 'package:file_picker/file_picker.dart';

class Gravacao extends StatelessWidget {
  const Gravacao({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MinhaGravacao(nomeArquivo: 'Flutter Demo Home Page'),
    );
  }
  // @override
  // State<Gravacao> createState() => _GravacaoState();
}

class MinhaGravacao extends StatefulWidget {
  MinhaGravacao({super.key, required this.nomeArquivo});
  final String nomeArquivo;

  @override
  State<MinhaGravacao> createState() => _MinhaGravacaoState();
}

class _MinhaGravacaoState extends State<MinhaGravacao> {
  final recorder = FlutterSoundRecorder();
  String musicaPath = '';
  bool isRecorderReady = false;

  @override
  void initState() {
    super.initState();
    initRecorder();
    getMusica();
  }

  Future getMusica() async {
    // load file from filepicker
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = File(result.files.single.path!);
      musicaPath = file.path;
    }
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Permissão do microfone não consedida!';
    }

    await recorder.openRecorder();
    isRecorderReady = true;

    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(
        toFile: widget.nomeArquivo); //aqui é escolhido o nome do arquivo
  }

  Future stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();

    final audioFile = File(path!);
    String audioPath = audioFile.path;
    print('Recorded audio path: $audioFile');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Player(
                  audioPath: audioPath,
                  musicaPath: musicaPath,
                  nomeArquivo: widget.nomeArquivo,
                  jaSalvo: false,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grave seu som"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<RecordingDisposition>(
              stream: recorder.onProgress,
              builder: (context, snapshot) {
                final duration =
                    snapshot.hasData ? snapshot.data!.duration : Duration.zero;

                String doisDigitos(int n) => n.toString().padLeft(2, '0');
                final minutos = doisDigitos(duration.inMinutes.remainder(60));
                final segundos = doisDigitos(duration.inSeconds.remainder(60));

                return Text(
                  '$minutos:$segundos',
                  style: const TextStyle(
                      fontSize: 80, fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              child:
                  Icon(recorder.isRecording ? Icons.stop : Icons.mic, size: 80),
              onPressed: () async {
                if (recorder.isRecording) {
                  await stop();
                  //Redirecionado para a tela de reprodução passando o path do audio

                } else {
                  await record();
                }

                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
