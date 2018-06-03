# pesarattu
A node/js debugger("inspection") plugin using the [chrome-remote-interface](https://www.npmjs.com/package/chrome-remote-interface). WIP.

Since the [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/) is accessible, there is a crazy goal to support web app debugging as well. pesarattu is being built to handle more than one "inspection" instance. This would let you debug multiple node/js applications at once from a single instance of vim.

## Usage

Use `:PesarattuDebug<instance>` to start debugging the instance as named in the config file.

Use `:PesarattuBPAdd` to set breakpoint over the line under cursor.

## Installation

Needs a server, [aragundu](https://github.com/srihari93/aragundu) for communicating with chrome devtools protocol provider. So run, `npm install` or `yarn` in the plugin's directory,

If you are using [vim-plug](https://github.com/junegunn/vim-plug) to manage your plugins, add `Plug 'srihari93/pesarattu', {'do': 'npm install'}` so that you don't have to worry about the updates to aragundu.
If you are using some other plugin manager, there would be a similar way to keep the dependency updated.

## Config

Needs a config file like this
```javascript
//
// Default config location: ~/.pesaratturc.js
// Config location is set via g:pesarattu#rc with full file path.
// Ex: let g:pesarattu#rc='/home/srihari/vankai/tenkai.js'
// Would recommend having the config for all "inspectable" applications at one place.
// pesarattu is being designed to handle multiple "inspections" at once.
//
module.exports = {

  // Multiple "inspectable" instances can be defined here.
  // The instance names are keys in the instances object.
  instances: {


    // The instance name is needed to start debugging Ex: `:PesarattuDebugworker`
    worker: {

      // Will add 'chrome-inspect' to debug web apps using chrome in the very far future.
      type: "node-inspect",

      // Please use full file paths
      command: "node --inspect /home/srihari/com.alyne/worker/app.js"
    },


    // The instance name is needed to start debugging Ex: `:PesarattuDebugapi`
    api: {

      type: "node-inspect",

      // Please use full file paths
      command: "node --inspect=9223 /home/srihari/com.alyne/api/app.js"
    }
  },

  aragundu: {

    // the port for communication with the server, aragundu
    port: 8765
  }
};
```

User configurable variables and their defaults
```vim
" The config file full path with the "inspectable" instances
let g:pesarattu#rc = $HOME . '/.pesaratturc.js'

" The socket for communication between pesarattu and aragundu
let g:pesarattu#socketPort = 8765

" The url for communication between pesarattu and aragundu
let g:pesarattu#socketURL = 'localhost'

" The time in ms to wait before pesarattu connects to aragundu
let g:pesarattu#socketURL = 500

" The log location for aragundu.
" The logs of the instances, are appended with their names ex: /tmp/aragundu.log<instane>
let g:pesarattu#aragundu#logs = $HOME . '/.aragundu.log'

" The log location for the communication between aragundu and pesarattu
let g:pesarattu#aragundu#comm#logs= $HOME . '/.pesarattu-aragundu-comm.log'

" The sign for active breakpoints
let g:pesarattu#breakpoint#active#sign = '●'

" The sign for inactive breakpoints. [ WIP ]
let g:pesarattu#breakpoint#inactive#sign = '○'

" Set this to receive more messages from pesarttu
let g:pesarattu#echom = 'echom'
```

## Todo
- [x] Use aragundu to read the config
- [x] Pass appropriate args to aragundu
- [x] Communicate with aragundu over sockets
- [x] Initiate an instance in the config for debugging
- [x] Add Breakpoints
- [x] Indicate Breakpoints
- [x] Enable logging to files
- [ ] Log files loadable in vim with commands
- [ ] Remove Breakpoints
- [ ] Respond to script paused events
- [ ] Take care of script resumed events
- [ ] Add a console
- [ ] Pipe logs to the console
- [ ] Evaluate input from console
- [ ] A command to list Breakpoints
