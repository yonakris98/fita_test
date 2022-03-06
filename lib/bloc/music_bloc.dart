import 'package:bloc/bloc.dart';
import 'package:fita_test/model/ListMusicModel.dart';
import 'package:fita_test/repository/music_repository.dart';
import 'package:rxdart/rxdart.dart';

class MusicBloc {
  final MusicRepository _repository = MusicRepository();
  final BehaviorSubject<ListMusicModel> _subject =
      BehaviorSubject<ListMusicModel>();

  getSearchArtist(data) async {
    ListMusicModel response = await _repository.getSearchArtist(data);
    _subject.sink.add(response);
  }

  Stream<ListMusicModel> get listMusic {
    return _subject.stream;
  }

  BehaviorSubject<ListMusicModel> get subject => _subject;
}

final blocMusic = MusicBloc();
