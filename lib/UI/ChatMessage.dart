import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Uteis.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;
  ChatMessage(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
                backgroundImage: NetworkImage(data[data_senderPhotoUrl])),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data[data_senderName],
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: data[data_imgUrl] != null
                      ? Image.network(
                          data[data_imgUrl],
                          width: 250.0,
                        )
                      : Text(data[data_text]))
            ],
          )),
        ],
      ),
    );
  }
}
