main(){
  List<String> list = ['安部', '97', '01', 'abcd', 'ABcd', '安部晋一郎'];
  list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  list.forEach((s){print(s);});
}
/*
01
97
abcd
ABcd
安部
安部晋一郎
*/
