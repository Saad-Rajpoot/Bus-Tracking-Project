import 'package:lu_bird/models/notice_model.dart';

import '../client/notice_client.dart';

class NoticeRepo {
  static final NoticeRepo _instance = NoticeRepo();
  NoticeClient? _noticeClient;

  NoticeClient getNoticeClient() {
    _noticeClient ??= NoticeClient();
    return _noticeClient!;
  }

  void initializeClient() {
    _noticeClient = NoticeClient();
  }

  static NoticeRepo get instance => _instance;

  Future<bool> createNotice(
      String name, String description, String imageUrl) async {
    int retry = 0;
    NoticeModel noticeModel =
        NoticeModel(name: name, description: description, imageUrl: imageUrl);

    bool response = false;

    while (retry++ < 2) {
      try {
        response = await NoticeRepo.instance
            .getNoticeClient()
            .createNotice(noticeModel);

        return response;
      } catch (err) {
        throw Exception("Something went wrong");
      }
    }
    return response;
  }

  Future<bool> updateNotice(
      String name, String description, String imageUrl, String id) async {

    int retry = 0;
    NoticeModel noticeModel =
    NoticeModel(name: name, description: description, imageUrl: imageUrl);

    bool response = false;

    while (retry++ < 2) {
      try {
        response = await NoticeRepo.instance
            .getNoticeClient()
            .updateNotice(noticeModel, id);

        return response;
      } catch (err) {
        throw Exception("Something went wrong");
      }
    }
    return response;
  }

  Future<List<NoticeModel>> getNotices(int skip) async {
    try {
      List<NoticeModel> response =
          await NoticeRepo.instance.getNoticeClient().getNotices(skip);

      return response;
    } catch (err) {
      throw Exception("Something went wrong");
    }
  }

  Future<bool> deleteNotice(String id, String imageUrl) async {
    try {
      bool response =
      await NoticeRepo.instance.getNoticeClient().deleteBus(id,imageUrl);

      return response;
    } catch (err) {
      throw Exception("Something went wrong");
    }
  }
}
