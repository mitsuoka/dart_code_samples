// Auto-generated from webuitest.html.
// DO NOT EDIT.

library webuitest_html;

import 'dart:html' as autogenerated;
import 'dart:svg' as autogenerated_svg;
import 'package:web_ui/web_ui.dart' as autogenerated;
import 'package:web_ui/observe/observable.dart' as __observe;


// Original code

    int count = 0;
    void increment() { count++; }
    main() {}
  
// Additional generated code
void init_autogenerated() {
  var _root = autogenerated.document.body;
  var __e0, __e2;
  var __t = new autogenerated.Template(_root);
  __e0 = _root.query('#__e-0');
  __t.listen(__e0.onClick, ($event) { increment(); });
  __e2 = _root.query('#__e-2');
  var __binding1 = __t.contentBind(() => count, false);
  __e2.nodes.addAll([new autogenerated.Text('(click count: '),
      __binding1,
      new autogenerated.Text(')')]);
  __t.create();
  __t.insert();
}

//@ sourceMappingURL=webuitest.html.dart.map