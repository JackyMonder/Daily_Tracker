// Common widgets exports
import 'package:daily_tracker/shared/widgets/MailIcon.dart';
import 'package:daily_tracker/shared/widgets/MenuIcon.dart';
import 'package:daily_tracker/shared/widgets/SettingIcon.dart';
import 'package:daily_tracker/shared/widgets/NoteCards.dart';
import 'package:daily_tracker/shared/widgets/HorizontalWeekView.dart';
import 'NewNote.dart';
import 'social_login_buttons.dart';
class CommonWidgets {
  // This class is just a placeholder to group common widgets if needed
  MenuIconButton get menuIconButton => MenuIconButton();
  MailIconButton get mailIconButton => MailIconButton();
  SettingIconButton get settingIconButton => SettingIconButton();
  NewNote get newNote => NewNote();
  Notecards get noteCards => Notecards();
  AppleCircle get appleCircle => AppleCircle();
  TwitterCircle get twitterCircle => TwitterCircle();
  GoogleCircle get googleCircle => GoogleCircle();
  FacebookCircle get facebookCircle => FacebookCircle();
  HorizontalWeekView get horizontalWeekView => HorizontalWeekView();
}