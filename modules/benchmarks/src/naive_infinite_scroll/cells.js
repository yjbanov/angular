import {int} from 'facade/lang';
import {reflector} from 'reflection/reflection';
import {getIntParameter, bindAction} from 'e2e_test_lib/benchmark_util';
import {bootstrap, Component, Template, TemplateConfig, ViewPort, Compiler}
    from 'angular/angular';
import {PromiseWrapper} from 'facade/async';
import {ListWrapper} from 'facade/collection';
import {Company, Opportunity, Offering, Account} from './common';

class CompanyNameComponent {
  width:String;
  company:Company;
}

class OpportunityNameComponent {
  width:String;
  opportunity:Opportunity;
}

class OfferingNameComponent {
  width:String;
  offering:Offering;
}

class Stage {
  name:String;
  isDisabled:boolean;
  style; // map
  apply; // function

  get styleString():String {
    return this.style != null
      ? this.style.keys
          .map((prop) => '$prop: ${this.style[prop]}')
          .join(';')
      : '';
  }
}

class StageButtonsComponent {
  _offering:Offering;
  stages:ListWrapper<Stage>;
  width:String;

  get offering():Offering { return _offering; }

  set offering(offering:Offering) {
    this._offering = offering;
    _computeStageButtons();
  }

  setStage(stage:Stage) {
    _offering.status = stage.name;
    _computeStageButtons();
  }

  _computeStageButtons() {
    var disabled = true;
    stages = STATUS_LIST
    .map(function(status:String) {
      var isCurrent = offering.status == status;
      var stage = new Stage();
      stage.name = status;
      stage.isDisabled = disabled;
      stage.style = {
          'background-color': disabled
            ? '#DDD'
            : isCurrent
              ? '#DDF'
              : '#FDD'
      };
      if (isCurrent) {
        disabled = false;
      }
      return stage;
    })
    .toList();
  }
}

class AccountCellComponent {
  account:Account;
  width:String;
}

class FormattedCellComponent {
  formattedValue:String;
  width:String;

  set value(value) {
    if (value instanceof DateTime) {
      formattedValue = '${value.month}/${value.day}/${value.year}';
    } else {
      formattedValue = value.toString();
    }
  }
}

function setupReflector() {
  reflector.registerType(CompanyNameComponent, {
    'factory': () => new CompanyNameComponent(),
    'parameters': [],
    'annotations': [
      new Component({
        selector: 'company-name',
        template: '<div style="width: {{width}}">{{company.name}}</div>',
        map: {
          'company': '=>company',
          'cell-width': '=>width',
        }
      })
    ]
  });

  reflector.registerType(OpportunityNameComponent, {
    'factory': () => new OpportunityNameComponent(),
    'parameters': [],
    'annotations': [
      new Component({
        selector: 'opportunity-name',
        template: '<div style="width: {{width}}">{{opportunity.name}}</div>',
        map: {
          'opportunity': '=>opportunity',
          'cell-width': '=>width',
        }
      })
    ]
  });

  reflector.registerType(OfferingNameComponent, {
    'factory': () => new OfferingNameComponent(),
    'parameters': [],
    'annotations': [
      new Component({
        selector: 'offering-name',
        template: '<div style="width: {{width}}">{{offering.name}}</div>',
        map: {
          'offering': '=>offering',
          'cell-width': '=>width',
        }
      })
    ]
  });

  reflector.registerType(StageButtonsComponent, {
    'factory': () => new StageButtonsComponent(),
    'parameters': [],
    'annotations': [
      new Component({
        selector: 'stage-buttons',
        template:
          '<div style="width: {{width}}">' +
              '<button ng-repeat="stage in stages" ' +
                      'ng-disabled="stage.isDisabled" ' +
                      'style="{{stage.styleString}}" ' +
                      'ng-click="setStage(stage)">' +
                '{{stage.name}}' +
              '</button>' +
          '</div>',
        map: {
          'offering': '=>offering',
          'cell-width': '=>width',
        }
      })
    ]
  });

  reflector.registerType(AccountCellComponent, {
    'factory': () => new AccountCellComponent(),
    'parameters': [],
    'annotations': [
      new Component({
        selector: 'account-cell',
        template:
          '<div style="width: {{width}}">' +
            '<a href="/account/{{account.accountId}}">' +
              '{{account.accountId}}' +
            '</a>' +
          '</div>',
        map: {
          'account': '=>account',
          'cell-width': '=>width',
        }
      })
    ]
  });

  reflector.registerType(FormattedCellComponent, {
    'factory': () => new FormattedCellComponent(),
    'parameters': [],
    'annotations': [
      new Component({
        selector: 'formatted-cell',
        template: '<div style="width: {{width}}">{{formattedValue}}</div>',
        map: {
          'value': '=>value',
          'cell-width': '=>width',
        }
      })
    ]
  });
}
