import 'dart:io';

import 'package:genius_lyrics/models/song.dart';

Future<void> writeTofile(
    {required String fileName,
    required String data,
    bool overwite = true,
    bool verbose = true}) async {
  try {
    File file = File(fileName);

    if (await file.exists() && overwite) {
      if (verbose) {
        print(
            "Skipping $fileName as file already exists and overwrite is true");
      }
      return;
    }

    file = await file.create(recursive: true);

    await file.writeAsString(data, mode: (FileMode.writeOnly));
  } catch (e) {
    if (verbose) {
      print('Error: ${e.toString()}');
    }
  }
}

Future<void> saveLyricsOfMultipleSongs(
    {required List<Song> songs,
    required String destPath,
    String ext = '.lrc',
    bool overwite = true,
    bool verbose = true}) async {
  if (!destPath.endsWith('/')) destPath += '/';
  int lyricNum = 1; // used in case the track title is null
  for (var song in songs) {
    String fileName = destPath + (song.title ?? 'lyric_${lyricNum++}') + ext;
    writeTofile(
        fileName: fileName,
        data: song.lyrics ?? '',
        overwite: overwite,
        verbose: verbose);
  }
}
