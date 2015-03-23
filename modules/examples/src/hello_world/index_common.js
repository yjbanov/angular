import {bootstrap, Component, Decorator, Template, NgElement} from 'angular2/angular2';
import {Injectable} from 'angular2/di';


@Component({selector: 'buttons-demo'})
@Template({
  directives: [GButtonComponent],
  inline: `
    <div>
      We are pushing disabled = {{disableSaveButton}} and text = {{saveButtonText}}.<br>
      <g-button (^click)="saveClicked()" type="primary" [disabled]="disableSaveButton">{{saveButtonText}}</g-button>
      <!-- <g-button (^click)="cancelClicked()">Cancel</g-button> -->
    </div>
  `
})
class ButtonsDemoViewComponent {
  _config:BindingPropagationConfig;
  _disableSaveButton;
  saveButtonText;

  constructor(c:BindingPropagationConfig) {
    this._config = c;
    this._disableSaveButton = false;
    this.saveButtonText = 'Save';
    print(`>>> For demo view, we are using ${this._config}.`);
  }

  cancelClicked() {}

  get disableSaveButton() {
    print(`>>> GET: disableSaveButton (${this._disableSaveButton})`);
    return this._disableSaveButton;
  }

  set disableSaveButton(value) {
    this._disableSaveButton = value;
  }

  saveClicked() {
    print(`>>> ON CLICK | For demo view, we are using ${this._config}.`);
    this.saveButtonText = 'Saving...';
    this.disableSaveButton = true;
  }
}

@Component({
  selector: 'g-button',
  bind: {
    'disabled': 'disabled',
    'type': 'type',
  }
})
@Template({
  inline: `
  <button [class.primary]="type == 'primary'" [disabled]="disabled">
    <content></content>
  </button>
  `
})
class GButtonComponent {
  type;
  _config:BindingPropagationConfig;
  _disabled:boolean;

  constructor(c:BindingPropagationConfig) {
    this.type = '';
    this._config = c;
    this._disabled = false;
    this._config.shouldBePropagated();
  }

  get disabled() { return _disabled; }

  set disabled(disabled) {
    print(`>>> Setting disabled to ${this.disabled}.`);
    this._disabled = disabled;
    // this._config.shouldBePropagatedFromRoot();
  }
}

export function main() {
  bootstrap(ButtonsDemoViewComponent);
}
