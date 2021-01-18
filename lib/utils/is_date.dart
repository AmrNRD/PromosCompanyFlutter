import 'package:intl/intl.dart';

String getIsDate(DateTime dateTime, {String customFormat}) {
  String format = customFormat ?? 'yyyy-MM-dd';
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  final aDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
  if (aDate == today)
    return "Today";
  else if (aDate == yesterday)
    return "Yesterday";
  else if (aDate == tomorrow)
    return "Tomorrow";
  else
    return DateFormat(format).format(dateTime);
}
bool isToday(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final aDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
 return aDate==today;
}

String getFormattedDate(DateTime dateTime, {String customFormat}) {
  String format = customFormat ?? 'yyyy-MM-dd';
    return DateFormat(format).format(dateTime);
}

DateTime startOfTheWeek(DateTime dateTime,{bool useSameTime=false}){
  int weekDay=dateTime.weekday;
  DateTime startOfTheWeek=dateTime.subtract(Duration(days: weekDay));
  final DateTime aDate = DateTime(startOfTheWeek.year, startOfTheWeek.month, startOfTheWeek.day,!useSameTime?0:dateTime.hour,!useSameTime?0:dateTime.minute,!useSameTime?0:dateTime.second);
  return aDate;
}

DateTime endOfTheWeek(DateTime dateTime,{bool useSameTime=false}){
  int weekDay=7-dateTime.weekday;
  DateTime startOfTheWeek=dateTime.add(Duration(days: weekDay));
  final DateTime aDate = DateTime(startOfTheWeek.year, startOfTheWeek.month, startOfTheWeek.day, !useSameTime?23:dateTime.hour,!useSameTime? 59:dateTime.minute,!useSameTime?59:dateTime.second, !useSameTime?999:dateTime.millisecond, !useSameTime?999:dateTime.microsecond);
  return aDate;
}


DateTime startOfTheMonth(int month,int year){
  final DateTime startOfTheMonth = DateTime(year, month,1,0,0,0);
  return startOfTheMonth;
}

DateTime endOfTheMonth(int month,int year){
  final DateTime startOfTheMonth = DateTime(year, month+1,0,23, 59, 59, 999, 999);
  return startOfTheMonth;
}

DateTime startOfTheQuarter(DateTime date){
  int quarterNumber = ((date.month-1)/3+1).toInt();
 return DateTime(date.year, (quarterNumber-1)*3+1,1);
}

DateTime endOfTheQuarter(DateTime date){
  int quarterNumber = ((date.month-1)/3+1).toInt();
  DateTime firstDayOfQuarter = new DateTime(date.year, (quarterNumber-1)*3+1,1);
  return DateTime(firstDayOfQuarter.year, firstDayOfQuarter.month+3,0,23, 59, 59, 999, 999);
}

DateTime startOfTheSemiAnnual(DateTime date){
  if(date.month>=6)
    return DateTime(date.year, 6,1,0,0,0);
  else
    return DateTime(date.year, 1,1,0,0,0);
}

DateTime endOfTheSemiAnnual(DateTime date){
  if(date.month>=6)
    return DateTime(date.year, 12,31,23, 59, 59, 999, 999);
  else
    return DateTime(date.year, 1,30,23, 59, 59, 999, 999);
}
DateTime startOfTheYear(int year){
  final DateTime startOfTheMonth = DateTime(year, 1,1,0,0,0);
  return startOfTheMonth;
}

DateTime endOfTheYear(int year){
  final DateTime startOfTheMonth = DateTime(year, 12,31,23, 59, 59, 999, 999);
  return startOfTheMonth;
}