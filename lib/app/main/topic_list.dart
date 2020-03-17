import 'package:flutter/material.dart';
import 'package:v2exreader/app/main/MainViewModel.dart';
import 'package:v2exreader/app/main/main.dart';

import '../../data/model/Topic.dart';
import '../../transparent_image.dart';
import '../../utils/logUtil.dart';

//话题列表
class TopicList extends StatefulWidget {
  TopicList({Key key, this.contentType}) : super(key: key);

  final int contentType;

  @override
  _TopicListState createState() => _TopicListState();
}

class _TopicListState extends State<TopicList> {

  MainViewModel _mainViewModel = MainViewModel.getInstance();

  //话题列表
  List<Topic> _topics;

  //刷新话题列表
  _refreshTopic() async {
    if (widget.contentType == HOT_TOPIC) {
      await _mainViewModel.refreshHotTopics();
    } else {
      await _mainViewModel.refreshLatestTopics();
    }
    setState(() {});
  }

  //文本间分割符
  Text _divider = Text("-");

  //列表item
  _item(Topic topic) {
    //作者头像
    Padding _avatar = Padding(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
      child: ClipRRect(
        child: FadeInImage.memoryNetwork(
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            placeholder: kTransparentImage,
            image: "https:" + topic.member.avatarLarge),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    //内容
    Expanded _content = Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 8),
          Text(
            topic.title,
            softWrap: true,
          ),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              ButtonTheme(
                minWidth: 0,
                height: 24,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: FlatButton(
                  child: Text(topic.node.name),
                  padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                  onPressed: () {},
                ),
              ),
              _divider,
              ButtonTheme(
                minWidth: 0,
                height: 24,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: FlatButton(
                  child: Text(topic.member.username),
                  padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                  onPressed: () {},
                ),
              ),
              _divider,
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: Text(
                    topic.fromNowTerm(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );

    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _avatar,
          _content,
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Text(
              topic.replies.toString(),
              style: TextStyle(color: Colors.black54),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Logs.d(message: "initState-${widget.contentType}");
    if (widget.contentType == HOT_TOPIC) {
      _topics = _mainViewModel.hotTopics;
    } else {
      _topics = _mainViewModel.latestTopics;
    }
    _refreshTopic();
  }

  @override
  Widget build(BuildContext context) {
    Logs.d(message: "build");
    return RefreshIndicator(
      child: ListView.builder(
          itemBuilder: (context, index) => _item(_topics[index]),
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _topics.length),
      onRefresh: () => _refreshTopic(),
    );
  }
}
