library benchmarks.src.naive_infinite_scroll.cells_dart;

import 'package:angular2/src/facade/lang.dart' show int;
import 'package:angular2/src/reflection/reflection.dart' show reflector;
import 'package:angular2/src/test_lib/benchmark_util.dart'
    show getIntParameter, bindAction;
import 'package:angular2/angular2.dart';
import 'package:angular2/src/core/compiler/binding_propagation_config.dart';
import 'package:angular2/src/facade/async.dart' show PromiseWrapper;
import 'package:angular2/src/facade/collection.dart'
    show ListWrapper, MapWrapper;
import './common.dart';
import 'package:angular2/directives.dart' show Foreach;

class HasStyle {
  final BindingPropagationConfig bpc;
  StreamSubscription sub;
  Map style;
  HasStyle(this.bpc) {
    this.style = MapWrapper.create();
    bpc.shouldBePropagated();
  }
  set width(w) {
    MapWrapper.set(this.style, 'width', w);
  }

  observe(entity) {
    if (sub != null) {
      sub.cancel();
      sub = null;
    }
    if (entity != null) {
      sub = entity.changes.listen((_) {
        bpc.shouldBePropagatedFromRoot();
      });
    }
  }
}
class CompanyNameComponent extends HasStyle {
  Company _company;

  CompanyNameComponent(BindingPropagationConfig bpc) : super(bpc);

  get company => _company;

  set company(Company c) {
    _company = c;
    observe(c);
  }
}
class OpportunityNameComponent extends HasStyle {
  Opportunity _opportunity;

  get opportunity => _opportunity;
  set opportunity(o) {
    _opportunity = o;
    observe(o);
  }

  OpportunityNameComponent(BindingPropagationConfig bpc) : super(bpc);
}
class OfferingNameComponent extends HasStyle {
  Offering _offering;

  get offering => _offering;
  set offering(o) {
    _offering = o;
    observe(o);
  }

  OfferingNameComponent(BindingPropagationConfig bpc) : super(bpc);
}

class Stage extends RawEntity {
  String get name => this['name'];
  set name(o) {
    this['name'] = o;
  }

  bool get isDisabled => this['isDisabled'];
  set isDisabled(o) {
    this['isDisabled'] = o;
  }

  ObservableMap get style => this['style'];
  set style(o) {
    this['style'] = o;
  }
}

class StageButtonsComponent extends HasStyle {
  Offering _offering;

  List<Stage> _stages;

  get stages => _stages;
  set stages(s) {
    _stages = s;
  }

  StageButtonsComponent(BindingPropagationConfig bpc) : super(bpc);
  Offering get offering {
    return this._offering;
  }
  set offering(Offering offering) {
    this._offering = offering;
    this._computeStageButtons();
    observe(offering);
  }
  setStage(Stage stage) {
    this._offering.status = stage.name;
    this._computeStageButtons();
    bpc.shouldBePropagatedFromRoot();
  }
  _computeStageButtons() {
    var disabled = true;
    this.stages = ListWrapper.clone(STATUS_LIST.map((status) {
      var isCurrent = this._offering.status == status;
      var stage = new Stage();
      stage.name = status;
      stage.isDisabled = disabled;
      var stageStyle = MapWrapper.create();
      MapWrapper.set(stageStyle, 'background-color',
          disabled ? '#DDD' : isCurrent ? '#DDF' : '#FDD');
      stage.style = stageStyle;
      if (isCurrent) {
        disabled = false;
      }
      return stage;
    }));
  }
}
class AccountCellComponent extends HasStyle {
  Account _account;

  get account => _account;
  set account(o) {
    _account = o;
    observe(o);
  }

  AccountCellComponent(BindingPropagationConfig bpc) : super(bpc);
}
class FormattedCellComponent extends HasStyle {
  String formattedValue;
  FormattedCellComponent(BindingPropagationConfig bpc) : super(bpc);
  set value(value) {
    if (value is CustomDate) {
      this.formattedValue = '''${value.month}/${value.day}/${value.year}''';
    } else {
      this.formattedValue = value.toString();
    }
  }
}
setupReflectorForCells() {
  reflector.registerType(CompanyNameComponent, {
    'factory': (a) {
      return new CompanyNameComponent(a);
    },
    'parameters': [[BindingPropagationConfig]],
    'annotations': [
      new Component(
          selector: 'company-name',
          template: new TemplateConfig(
              directives: [],
              inline: '''<div [style]=\"style\">{{company.name}}</div>'''),
          bind: {'cell-width': 'width', 'company': 'company'})
    ]
  });
  reflector.registerType(OpportunityNameComponent, {
    'factory': (a) {
      return new OpportunityNameComponent(a);
    },
    'parameters': [[BindingPropagationConfig]],
    'annotations': [
      new Component(
          selector: 'opportunity-name',
          template: new TemplateConfig(
              directives: [],
              inline: '''<div [style]=\"style\">{{opportunity.name}}</div>'''),
          bind: {'cell-width': 'width', 'opportunity': 'opportunity'})
    ]
  });
  reflector.registerType(OfferingNameComponent, {
    'factory': (a) {
      return new OfferingNameComponent(a);
    },
    'parameters': [[BindingPropagationConfig]],
    'annotations': [
      new Component(
          selector: 'offering-name',
          template: new TemplateConfig(
              directives: [],
              inline: '''<div [style]=\"style\">{{offering.name}}</div>'''),
          bind: {'cell-width': 'width', 'offering': 'offering'})
    ]
  });
  reflector.registerType(StageButtonsComponent, {
    'factory': (a) {
      return new StageButtonsComponent(a);
    },
    'parameters': [[BindingPropagationConfig]],
    'annotations': [
      new Component(
          selector: 'stage-buttons',
          template: new TemplateConfig(directives: [Foreach], inline: '''
              <div [style]=\"style\">
                  <button template=\"foreach #stage in stages\"
                          [disabled]=\"stage.isDisabled\"
                          [style]=\"stage.style\"
                          on-click=\"setStage(stage)\">
                    {{stage.name}}
                  </button>
              </div>'''), bind: {'cell-width': 'width', 'offering': 'offering'})
    ]
  });
  reflector.registerType(AccountCellComponent, {
    'factory': (a) {
      return new AccountCellComponent(a);
    },
    'parameters': [[BindingPropagationConfig]],
    'annotations': [
      new Component(
          selector: 'account-cell',
          template: new TemplateConfig(directives: [], inline: '''
              <div [style]=\"style\">
                <a href=\"/account/{{account.accountId}}\">
                  {{account.accountId}}
                </a>
              </div>'''), bind: {'cell-width': 'width', 'account': 'account'})
    ]
  });
  reflector.registerType(FormattedCellComponent, {
    'factory': (a) {
      return new FormattedCellComponent(a);
    },
    'parameters': [[BindingPropagationConfig]],
    'annotations': [
      new Component(
          selector: 'formatted-cell',
          template: new TemplateConfig(
              directives: [],
              inline: '''<div [style]=\"style\">{{formattedValue}}</div>'''),
          bind: {'cell-width': 'width', 'value': 'value'})
    ]
  });
}
