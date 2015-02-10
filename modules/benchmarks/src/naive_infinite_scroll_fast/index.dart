library benchmarks.src.naive_infinite_scroll.index_dart;

import 'package:angular2/src/facade/lang.dart' show int, isBlank;
import 'package:angular2/src/facade/dom.dart' show Element;
import 'package:angular2/src/facade/collection.dart' show MapWrapper;
import 'package:angular2/change_detection.dart'
    show Parser, Lexer, ChangeDetector, ChangeDetection;
import 'package:angular2/angular2.dart';
import 'package:angular2/src/core/compiler/binding_propagation_config.dart';
import 'package:angular2/src/reflection/reflection.dart' show reflector;
import 'package:angular2/src/core/compiler/compiler.dart' show CompilerCache;
import 'package:angular2/src/core/compiler/directive_metadata_reader.dart'
    show DirectiveMetadataReader;
import 'package:angular2/src/core/compiler/shadow_dom_strategy.dart'
    show ShadowDomStrategy, NativeShadowDomStrategy;
import 'package:angular2/src/core/compiler/template_loader.dart'
    show TemplateLoader;
import 'package:angular2/src/core/life_cycle/life_cycle.dart' show LifeCycle;
import 'package:angular2/src/core/compiler/xhr/xhr.dart' show XHR;
import 'package:angular2/src/core/compiler/xhr/xhr_impl.dart' show XHRImpl;
import 'package:angular2/directives.dart' show If, Foreach;
import './app.dart' show App, setupReflectorForApp;
import './scroll_area.dart'
    show ScrollAreaComponent, setupReflectorForScrollArea;
import './scroll_item.dart'
    show ScrollItemComponent, setupReflectorForScrollItem;
import './cells.dart'
    show
        CompanyNameComponent,
        OpportunityNameComponent,
        OfferingNameComponent,
        AccountCellComponent,
        StageButtonsComponent,
        FormattedCellComponent,
        setupReflectorForCells;

main() {
  setupReflector();
  bootstrap(App);
}
setupReflector() {
  setupReflectorForAngular();
  setupReflectorForApp();
  setupReflectorForScrollArea();
  setupReflectorForScrollItem();
  setupReflectorForCells();
  var evt = '''\$event''';
  reflector.registerGetters({
    'scrollAreas': (o) {
      return o.scrollAreas;
    },
    'length': (o) {
      return o.length;
    },
    'iterable': (o) {
      return o.iterable;
    },
    'scrollArea': (o) {
      return o.scrollArea;
    },
    'item': (o) {
      return o.item;
    },
    'visibleItems': (o) {
      return o.visibleItems;
    },
    'condition': (o) {
      return o.condition;
    },
    'width': (o) {
      return o.width;
    },
    'value': (o) {
      return o.value;
    },
    'href': (o) {
      return o.href;
    },
    'company': (o) {
      return o.company;
    },
    'formattedValue': (o) {
      return o.formattedValue;
    },
    'name': (o) {
      return o.name;
    },
    'style': (o) {
      return o.style;
    },
    'offering': (o) {
      return o.offering;
    },
    'account': (o) {
      return o.account;
    },
    'accountId': (o) {
      return o.accountId;
    },
    'companyNameWidth': (o) {
      return o.companyNameWidth;
    },
    'opportunityNameWidth': (o) {
      return o.opportunityNameWidth;
    },
    'offeringNameWidth': (o) {
      return o.offeringNameWidth;
    },
    'accountCellWidth': (o) {
      return o.accountCellWidth;
    },
    'basePointsWidth': (o) {
      return o.basePointsWidth;
    },
    'scrollDivStyle': (o) {
      return o.scrollDivStyle;
    },
    'paddingStyle': (o) {
      return o.paddingStyle;
    },
    'innerStyle': (o) {
      return o.innerStyle;
    },
    'opportunity': (o) {
      return o.opportunity;
    },
    'itemStyle': (o) {
      return o.itemStyle;
    },
    'dueDateWidth': (o) {
      return o.dueDateWidth;
    },
    'basePoints': (o) {
      return o.basePoints;
    },
    'kickerPoints': (o) {
      return o.kickerPoints;
    },
    'kickerPointsWidth': (o) {
      return o.kickerPointsWidth;
    },
    'bundles': (o) {
      return o.bundles;
    },
    'stageButtonsWidth': (o) {
      return o.stageButtonsWidth;
    },
    'bundlesWidth': (o) {
      return o.bundlesWidth;
    },
    'disabled': (o) {
      return o.disabled;
    },
    'isDisabled': (o) {
      return o.isDisabled;
    },
    'dueDate': (o) {
      return o.dueDate;
    },
    'endDate': (o) {
      return o.endDate;
    },
    'aatStatus': (o) {
      return o.aatStatus;
    },
    'stage': (o) {
      return o.stage;
    },
    'stages': (o) {
      return o.stages;
    },
    'aatStatusWidth': (o) {
      return o.aatStatusWidth;
    },
    'endDateWidth': (o) {
      return o.endDateWidth;
    },
    evt: (o) {
      return null;
    }
  });
  reflector.registerSetters({
    'scrollAreas': (o, v) {
      return o.scrollAreas = v;
    },
    'length': (o, v) {
      return o.length = v;
    },
    'condition': (o, v) {
      return o.condition = v;
    },
    'scrollArea': (o, v) {
      return o.scrollArea = v;
    },
    'item': (o, v) {
      return o.item = v;
    },
    'visibleItems': (o, v) {
      return o.visibleItems = v;
    },
    'iterable': (o, v) {
      return o.iterable = v;
    },
    'width': (o, v) {
      return o.width = v;
    },
    'value': (o, v) {
      return o.value = v;
    },
    'company': (o, v) {
      return o.company = v;
    },
    'name': (o, v) {
      return o.name = v;
    },
    'offering': (o, v) {
      return o.offering = v;
    },
    'account': (o, v) {
      return o.account = v;
    },
    'accountId': (o, v) {
      return o.accountId = v;
    },
    'formattedValue': (o, v) {
      return o.formattedValue = v;
    },
    'stage': (o, v) {
      return o.stage = v;
    },
    'stages': (o, v) {
      return o.stages = v;
    },
    'disabled': (o, v) {
      return o.disabled = v;
    },
    'isDisabled': (o, v) {
      return o.isDisabled = v;
    },
    'href': (o, v) {
      return o.href = v;
    },
    'companyNameWidth': (o, v) {
      return o.companyNameWidth = v;
    },
    'opportunityNameWidth': (o, v) {
      return o.opportunityNameWidth = v;
    },
    'offeringNameWidth': (o, v) {
      return o.offeringNameWidth = v;
    },
    'accountCellWidth': (o, v) {
      return o.accountCellWidth = v;
    },
    'basePointsWidth': (o, v) {
      return o.basePointsWidth = v;
    },
    'scrollDivStyle': (o, v) {
      return o.scrollDivStyle = v;
    },
    'paddingStyle': (o, v) {
      return o.paddingStyle = v;
    },
    'innerStyle': (o, v) {
      return o.innerStyle = v;
    },
    'opportunity': (o, v) {
      return o.opportunity = v;
    },
    'itemStyle': (o, v) {
      return o.itemStyle = v;
    },
    'basePoints': (o, v) {
      return o.basePoints = v;
    },
    'kickerPoints': (o, v) {
      return o.kickerPoints = v;
    },
    'kickerPointsWidth': (o, v) {
      return o.kickerPointsWidth = v;
    },
    'stageButtonsWidth': (o, v) {
      return o.stageButtonsWidth = v;
    },
    'dueDate': (o, v) {
      return o.dueDate = v;
    },
    'dueDateWidth': (o, v) {
      return o.dueDateWidth = v;
    },
    'endDate': (o, v) {
      return o.endDate = v;
    },
    'endDateWidth': (o, v) {
      return o.endDate = v;
    },
    'aatStatus': (o, v) {
      return o.aatStatus = v;
    },
    'aatStatusWidth': (o, v) {
      return o.aatStatusWidth = v;
    },
    'bundles': (o, v) {
      return o.bundles = v;
    },
    'bundlesWidth': (o, v) {
      return o.bundlesWidth = v;
    },
    evt: (o, v) {
      return null;
    },
    'style': (o, m) {
      MapWrapper.forEach(m, (v, k) {
        o.style.setProperty(k, v);
      });
    }
  });
  reflector.registerMethods({
    'onScroll': (o, args) {
      o.onScroll(args[0]);
    },
    'setStage': (o, args) {
      return o.setStage(args[0]);
    }
  });
}
setupReflectorForAngular() {
  reflector.registerType(BindingPropagationConfig, {
    'factory': (cd) => new BindingPropagationConfig(cd),
    'parameters': [[ChangeDetector]],
  });
  reflector.registerType(If, {
    'factory': (vp) {
      return new If(vp);
    },
    'parameters': [[ViewPort]],
    'annotations': [new Template(selector: '[if]', bind: {'if': 'condition'})]
  });
  reflector.registerType(Foreach, {
    'factory': (vp) {
      return new Foreach(vp);
    },
    'parameters': [[ViewPort]],
    'annotations': [
      new Template(selector: '[foreach]', lifecycle: ['onChange'], bind: {'in': 'iterable[]'})
    ]
  });
  reflector.registerType(Compiler, {
    "factory": (changeDetection, templateLoader, reader, parser, compilerCache,
        shadowDomStrategy) {
      return new Compiler(changeDetection, templateLoader, reader, parser,
          compilerCache, shadowDomStrategy);
    },
    "parameters": [
      [ChangeDetection],
      [TemplateLoader],
      [DirectiveMetadataReader],
      [Parser],
      [CompilerCache],
      [ShadowDomStrategy]
    ],
    "annotations": []
  });
  reflector.registerType(CompilerCache, {
    'factory': () {
      return new CompilerCache();
    },
    'parameters': [],
    'annotations': []
  });
  reflector.registerType(Parser, {
    'factory': (lexer) {
      return new Parser(lexer);
    },
    'parameters': [[Lexer]],
    'annotations': []
  });
  reflector.registerType(TemplateLoader, {
    "factory": (xhr) {
      return new TemplateLoader(xhr);
    },
    "parameters": [[XHR]],
    "annotations": []
  });
  reflector.registerType(XHR, {
    "factory": () {
      return new XHRImpl();
    },
    "parameters": [],
    "annotations": []
  });
  reflector.registerType(DirectiveMetadataReader, {
    'factory': () {
      return new DirectiveMetadataReader();
    },
    'parameters': [],
    'annotations': []
  });
  reflector.registerType(Lexer, {
    'factory': () {
      return new Lexer();
    },
    'parameters': [],
    'annotations': []
  });
  reflector.registerType(LifeCycle, {
    "factory": (cd) {
      return new LifeCycle(cd);
    },
    "parameters": [[ChangeDetector]],
    "annotations": []
  });
  reflector.registerType(ShadowDomStrategy, {
    "factory": () {
      return new NativeShadowDomStrategy();
    },
    "parameters": [],
    "annotations": []
  });
}
