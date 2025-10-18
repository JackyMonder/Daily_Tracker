// Common widgets exports
import 'package:expenses_app/common/widgets/MailIcon.dart';
import 'package:expenses_app/common/widgets/MenuIcon.dart';
import 'package:expenses_app/common/widgets/SettingIcon.dart';
import 'package:expenses_app/common/widgets/SearchBar.dart';
import 'package:expenses_app/common/widgets/NoteCards.dart';
import 'NewNote.dart';
import 'social_login_buttons.dart';
class CommonWidgets {
  // This class is just a placeholder to group common widgets if needed
  MenuIconButton get menuIconButton => MenuIconButton();
  MailIconButton get mailIconButton => MailIconButton();
  SettingIconButton get settingIconButton => SettingIconButton();
  NewNote get newNote => NewNote();
  Searchbar get searchBar => Searchbar();
  Notecards get noteCards => Notecards();
  AppleCircle get appleCircle => AppleCircle();
  TwitterCircle get twitterCircle => TwitterCircle();
  GoogleCircle get googleCircle => GoogleCircle();
  FacebookCircle get facebookCircle => FacebookCircle();
}