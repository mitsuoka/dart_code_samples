main(){
  var age = 20;
  if( age > 18 ){
    print('Qualifies for driving');
  }

  bool password = false;
  if(password){
   print('You are eligible');
  }else{
  print('Sorry, not eligible');
  }

  DateTime now = new DateTime.now();
  DateTime deadline = new DateTime(2013, 2, 25, 0, 0, 0, 0);
  if (now.difference(deadline).inDays > 0) print('Expired!');

  String myFriend = 'Tom';
  if (myFriend == 'Bll') print('Hello');
  else print('Who are you?');
}
/*
Qualifies for driving
Sorry, not eligible
Expired!
Who are you?
*/
