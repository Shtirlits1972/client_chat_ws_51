class MessageChat {
  String NameUser = "";
  String Text = "";
  TypeOfMessage type = TypeOfMessage.Text;

  MessageChat(this.NameUser, this.Text, this.type);

  MessageChat.fromJson(Map<String, dynamic> json)
      : NameUser = json['NameUser'],
        type = json['type'],
        Text = json['Text'];

  Map<String, dynamic> toJson() => {
        "NameUser": NameUser,
        "Text": Text,
        "type": type,
      };

  @override
  String toString() {
    return 'NameUser = $NameUser, Text = $Text, type = $type ';
  }
}

enum TypeOfMessage { Text, LogIn, Error, Success, ServerInfo }
