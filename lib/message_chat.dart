class MessageChat {
  // String LoginUser = '';
  String NameUser = "";
  String Text = "";
  TypeOfMessage type = TypeOfMessage.Text;

  MessageChat(this.NameUser, this.Text, this.type);

  MessageChat.fromJson(Map<String, dynamic> json)
      : NameUser = json['NameUser'],
        type = TypeOfMessage.values[json['type']],
        Text = json['Text'];

  Map<String, dynamic> toJson() => {
        "NameUser": NameUser,
        "Text": Text,
        "type": TypeOfMessage.values.indexOf(type),
      };

  @override
  String toString() {
    return 'NameUser = $NameUser, Text = $Text, type = $type ';
  }
}

enum TypeOfMessage { Text, LogIn, Error, Success, ServerInfo, Register }
