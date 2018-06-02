# pesarattu

## Installation

Needs a server, [aragundu](https://www.npmjs.com/package/aragundu) for communicating with chrome devtools protocol provider. So run, `npm install` or `yarn` in the plugin's directory,

If you are using [vim-plug](https://github.com/junegunn/vim-plug) to manage your plugins, add `Plug 'srihari93/pesarattu', {'do': 'npm install'}` so that you don't have to worry about the updates to aragundu.
If you are using some other plugin manager, there would be a similar way to keep the dependency updated.

## Config

Needs a config file like this
```
//
// Default config location: ~/.pesaratturc.js
// Config location is set via g:pesarattu#rc with full file path.
// Ex: let g:pesarattu#rc='/home/srihari/vankai/tenkai.js'
// Would recommend having the config for all "inspectable" applications at one place.
// pesarattu is being designed to handle multiple "inspections" at once.
//
module.exports = {

  // Multiple "inspectable" instances can be defined here
  instances: {
    worker: {
      // Will add 'chrome-inspect' to debug web apps using chrome in the very far future.
      type: "node-inspect",
      // Please use full file paths
      command: "node --inspect /home/srihari/com.alyne/worker/app.js"
    },
    api: {
      type: "node-inspect",
      // Please use full file paths
      command: "node --inspect=9223 /home/srihari/com.alyne/api/app.js"
    }
  },

  aragundu: {
    // the port for communication with the server, aragundu
    port: 8080
  }
};
```


## Todo
- [x] Use aragundu to read the config
- [x] Pass appropriate args to aragundu
- [x] Communicate with aragundu over sockets
- [x] Initiate an instance in the config for debugging
- [x] Add Breakpoints
- [x] Indicate Breakpoints
- [ ] Remove Breakpoints
- [ ] Respond to script paused events
- [ ] Take care of script resumed events
- [ ] Add a console
- [ ] Pipe logs to the console
- [ ] Evaluate input from console
- [ ] A command to list Breakpoints
