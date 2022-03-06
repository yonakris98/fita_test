// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:fita_test/bloc/music_bloc.dart';
import 'package:fita_test/model/ListMusicModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioPlayer audioPlayer = AudioPlayer();

  MusicBloc musicBloc = MusicBloc();
  ListMusicModel listMusic = ListMusicModel();

  int flagPlay;
  String playSong;
  bool isPaused = false, isTyping = false, isSearch = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _searchArtist(value) {
    if (value == null || value == '') {
      return null;
    }
    print('hit search');
    flagPlay = null;
    isSearch = false;
    value.replaceAll(' ', '+');
    musicBloc.getSearchArtist(value);
  }

  Widget _buildEmptyWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Text(
          'No Music Found',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Error occured",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listMusicWidget(ListMusicModel data) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.resultCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: InkWell(
                  onTap: () async {
                    int result =
                        await audioPlayer.play(data.results[index].previewUrl);
                    if (result == 1) {
                      // success
                      print('play');
                      setState(() {
                        playSong = data.results[index].trackName;
                        flagPlay = index;
                        isPaused = false;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 26, 25, 25).withOpacity(0.6),
                      // border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              data.results[index].artworkUrl100,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data.results[index].trackName ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        data.results[index].artistName ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flagPlay == index
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: Icon(
                                              Icons.music_note_outlined,
                                              color: Colors.green,
                                              size: 24,
                                            ),
                                          )
                                        : SizedBox.shrink()
                                  ],
                                ),
                                Text(
                                  data.results[index].collectionName ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        flagPlay != null ||
                isPaused == false && isTyping == false ||
                isPaused == false && isSearch == false
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(176, 0, 0, 0),
                    // border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          playSong ?? "Pick your music",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              int result = await audioPlayer
                                  .play(data.results[flagPlay - 1].previewUrl);
                              if (result == 1) {
                                // success
                                print('play');
                                setState(() {
                                  playSong =
                                      data.results[flagPlay - 1].trackName;
                                  flagPlay = flagPlay - 1;
                                  isPaused = false;
                                });
                              }
                            },
                            child: FaIcon(
                              FontAwesomeIcons.backward,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (isPaused == false) {
                                  isPaused = true;
                                  audioPlayer.pause();
                                } else {
                                  isPaused = false;
                                  audioPlayer.resume();
                                }
                              });
                            },
                            child: FaIcon(
                              isPaused
                                  ? FontAwesomeIcons.play
                                  : FontAwesomeIcons.pause,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              int result = await audioPlayer
                                  .play(data.results[flagPlay + 1].previewUrl);
                              if (result == 1) {
                                // success
                                print('play');
                                setState(() {
                                  playSong =
                                      data.results[flagPlay + 1].trackName;
                                  flagPlay = flagPlay + 1;
                                  isPaused = false;
                                });
                              }
                            },
                            child: FaIcon(
                              FontAwesomeIcons.forward,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 5, 38, 77),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextField(
                onTap: () {
                  setState(() {
                    isSearch = true;
                    print("search " +
                        isSearch.toString() +
                        " " +
                        "pause " +
                        isPaused.toString() +
                        " " +
                        "typing" +
                        isTyping.toString());
                  });
                },
                onSubmitted: (value) {
                  setState(() async {
                    await _searchArtist(value);
                  });
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    fillColor: Colors.grey[300],
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20.0)),
                    hintText: 'Search artist name'),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: StreamBuilder<ListMusicModel>(
                  stream: musicBloc.listMusic,
                  builder: (context, AsyncSnapshot<ListMusicModel> snapshot) {
                    if (snapshot.data != null) {
                      return _listMusicWidget(snapshot.data);
                    } else if (snapshot.data == null) {
                      return _buildEmptyWidget();
                    } else {
                      return _buildErrorWidget();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
