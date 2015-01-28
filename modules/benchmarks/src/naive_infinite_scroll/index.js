import {int} from 'facade/lang';
import {Element} from 'facade/dom';

import {bootstrap, Component, Template, TemplateConfig, ViewPort, Compiler}
    from 'angular/angular';
import {reflector} from 'reflection/reflection';

import {App} from './app';
import {ScrollAreaComponent} from './scroll_area';
import {ScrollItemComponent} from './scroll_item';
import {CompanyNameComponent, OpportunityNameComponent, OfferingNameComponent,
    AccountCellComponent, StageButtonsComponent, FormattedCellComponent}
        from './cells';

export function main() {
  setupReflector();
  bootstrap(App);
}

function setupReflector() {
  reflector.registerType(App, {
    'factory': new App(),
    'parameters': [],
    'annotations': []
  });

  reflector.registerType(ScrollAreaComponent, {
    'factory': new ScrollAreaComponent(),
    'parameters': [],
    'annotations': []
  });

  reflector.registerType(ScrollItemComponent, {
    'factory': new ScrollItemComponent(),
    'parameters': [],
    'annotations': []
  });

  reflector.registerType(CompanyNameComponent, {
    'factory': new CompanyNameComponent(),
    'parameters': [],
    'annotations': []
  });

  reflector.registerType(OpportunityNameComponent, {
    'factory': new OpportunityNameComponent(),
    'parameters': [],
    'annotations': []
  });

  reflector.registerType(OfferingNameComponent, {
    'factory': new OfferingNameComponent(),
    'parameters': [],
    'annotations': []
  });

  reflector.registerType(AccountCellComponent, {
    'factory': new AccountCellComponent(),
    'parameters': [],
    'annotations': []
  });

  reflector.registerType(StageButtonsComponent, {
    'factory': new StageButtonsComponent(),
    'parameters': [],
    'annotations': []
  });

  reflector.registerType(FormattedCellComponent, {
    'factory': new FormattedCellComponent(),
    'parameters': [],
    'annotations': []
  });
}
