class MessageChat {
  String LoginEmail = '';
  String NameUser = "";
  String Text = "";
  DateTime DataMsg;
  TypeOfMessage type = TypeOfMessage.Text;

  MessageChat(
      this.LoginEmail, this.NameUser, this.Text, this.DataMsg, this.type);

  MessageChat.fromJson(Map<String, dynamic> json)
      : LoginEmail = json['LoginEmail'],
        NameUser = json['NameUser'],
        DataMsg = DateTime.parse(json['DataMsg'].toString()),
        type = TypeOfMessage.values[json['type']],
        Text = json['Text'];

  Map<String, dynamic> toJson() => {
        "LoginEmail": LoginEmail,
        "NameUser": NameUser,
        "Text": Text,
        "DataMsg": DataMsg.toString(),
        "type": TypeOfMessage.values.indexOf(type),
      };

  @override
  String toString() {
    return 'LoginEmail = $LoginEmail, NameUser = $NameUser, Text = $Text, DataMsg = $DataMsg, type = $type ';
  }
}

enum TypeOfMessage { Text, LogIn, Error, Success, ServerInfo, Register }
