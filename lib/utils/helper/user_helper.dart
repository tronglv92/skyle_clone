class UserHelper{
  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial="";
    String lastNameInitial="";
    if(nameSplit.length>0)
     firstNameInitial = nameSplit[0][0];
    if(nameSplit.length>1)
     lastNameInitial = nameSplit[1][0];
    return firstNameInitial + lastNameInitial;
  }
  // static int stateToNum(UserState userState) {
  //   switch (userState) {
  //     case UserState.Offline:
  //       return 0;
  //
  //     case UserState.Online:
  //       return 1;
  //
  //     default:
  //       return 2;
  //   }
  // }
  //
  // static UserState numToState(int number) {
  //   switch (number) {
  //     case 0:
  //       return UserState.Offline;
  //
  //     case 1:
  //       return UserState.Online;
  //
  //     default:
  //       return UserState.Waiting;
  //   }
  // }

}
