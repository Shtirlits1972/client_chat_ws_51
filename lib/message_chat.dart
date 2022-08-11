class MessageChat {
  String NameUser = "";
  String Text = "";

  MessageChat(this.NameUser, this.Text);

  MessageChat.fromJson(Map<String, dynamic> json)
      : NameUser = json['NameUser'],
        Text = json['Text'];

  Map<String, dynamic> toJson() => {
        "NameUser": NameUser,
        "Text": Text,
      };

  @override
  String toString() {
    return 'NameUser = $NameUser, Text = $Text';
  }
}
