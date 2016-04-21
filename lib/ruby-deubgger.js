'use babel';

import RubyDeubggerView from './ruby-deubgger-view';
import { CompositeDisposable } from 'atom';

export default {

  rubyDeubggerView: null,
  modalPanel: null,
  subscriptions: null,

  activate(state) {
    this.rubyDeubggerView = new RubyDeubggerView(state.rubyDeubggerViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.rubyDeubggerView.getElement(),
      visible: false
    });

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'ruby-deubgger:toggle': () => this.toggle()
    }));
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.rubyDeubggerView.destroy();
  },

  serialize() {
    return {
      rubyDeubggerViewState: this.rubyDeubggerView.serialize()
    };
  },

  toggle() {
    console.log('RubyDeubgger was toggled!');
    return (
      this.modalPanel.isVisible() ?
      this.modalPanel.hide() :
      this.modalPanel.show()
    );
  }

};
