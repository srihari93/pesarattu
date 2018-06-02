" Defaults configurable by users
if !exists('g:pesarattu#rc')
  let g:pesarattu#rc = $HOME . '/.pesaratturc.js'
endif
if !exists('g:pesarattu#socketPort')
  let g:pesarattu#socketPort = 8765
endif
if !exists('g:pesarattu#socketURL')
  let g:pesarattu#socketURL = 'localhost'
endif
if !exists('g:pesarattu#aragundu#logs')
  let g:pesarattu#aragundu#logs = $HOME . '/.aragundu.log'
endif
if !exists('g:pesarattu#aragundu#comm#logs')
  let g:pesarattu#aragundu#comm#logs= $HOME . '/.pesarattu-aragundu-comm.log'
endif

if !exists('g:pesarattu#breakpoint#active#sign')
  let g:pesarattu#breakpoint#active#sign = '●'
endif

if !exists('g:pesarattu#breakpoint#inactive#sign')
  let g:pesarattu#breakpoint#inactive#sign = '○'
endif

execute 'sign define PesarattuBPActive text=' . g:pesarattu#breakpoint#active#sign
execute 'sign define PesarattuBPInactive text=' . g:pesarattu#breakpoint#inactive#sign

let s:aragunduURL = g:pesarattu#socketURL . ':' . g:pesarattu#socketPort

func! s:PesarattuEchom(m)
  if exists('g:pesarattu#echom')
    echom a:m
  endif
endfunc

call s:PesarattuEchom ('Pesarattu: starting aragundu server at:' . s:aragunduURL)

" global variables
" s:aragunduChannel
" s:pesrattuInstances

func! s:AddDebugInstances(instances)
  for l:i in a:instances
    execute 'command! PesarattuDebug'.l:i. ' call PesarattuDebug("'.l:i.'")'
  endfor
endfunc

func! g:PesarattuAragunduHandler(channel, m)
  if type(a:m)==type('')
    echom 'Pesarattu:' . a:m
  elseif type(a:m)==type({}) && has_key(a:m,'instances')
    let s:pesarattuInstances = a:m.instances
    call s:AddDebugInstances(a:m.instances)
  else
    echom 'Pesarattu.aragunu:' 
    echom a:m
  endif
endfunc

func! Pesarattu#connect()
  if(exists('s:aragunduChannel') && ch_status(s:aragunduChannel) ==# 'open')
    echom 'Pesarattu: already connected to server, aragundu: ' . s:aragunduChannel
    return
  endif
  call ch_logfile(g:pesarattu#aragundu#comm#logs, 'w')
  let s:aragunduChannel = ch_open(s:aragunduURL, {'callback':'g:PesarattuAragunduHandler'})
  if( ch_status(s:aragunduChannel) !=# 'open')
    call s:PesarattuEchom ('Pesarattu: failed to connnect to server, aragundu: ' . s:aragunduChannel)
    return
  endif
  call s:PesarattuEchom( 'Pesarattu: connected to server, aragundu: ' . s:aragunduChannel)
endfunc

func! PesarattuBurn()
  if(exists('s:aragunduChannel') && ch_status(s:aragunduChannel) ==# 'open')
    call ch_close(s:aragunduChannel)
    unlet s:aragunduChannel
  endif
  if(exists('s:aragundu'))
    call job_stop(s:aragundu)
    unlet s:aragundu
  endif
endfunc

func! g:PesarattuPrepUI(ch,m)
  if type(a:m) == type({}) && has_key(a:m, 'instance') && has_key(a:m, 'status') && a:m.status ==# 'success'
    let g:PesarattuActiveInstance = a:m.instance 
  endif
endfunc

func! g:PesarattuSetBPResp(ch,m)
  for l:l in a:m.locations
    let l:line = string(l:l.lineNumber)
    execute 'sign place ' . l:line . ' line=' . l:line . ' name=PesarattuBPActive file=' . l:l.url
  endfor
endfunc

func! PesarattuSetBreakPoint()
  if !exists('g:PesarattuActiveInstance')
    echom 'Pesarattu: No instance is active. Try :PesarattuDebug<instance>'
  endif
  let l:msg = {}
  let l:msg.attu = 'setBP'
  let l:msg.instance = g:PesarattuActiveInstance
  let l:msg.lineNumber = line('.')
  let l:msg.url = expand('%:p')
  call ch_sendexpr(s:aragunduChannel, l:msg, {'callback': 'g:PesarattuSetBPResp'})
endfunc

func! PesarattuDebug(instance)
  " if pesarattu is not connected, connect it
  if(!exists('s:aragunduChannel') || ch_status(s:aragunduChannel) !=# 'open')
    PesarattuStart
  endif
  call ch_sendexpr(s:aragunduChannel, {'attu':'debug' , 'instance':a:instance}, {'callback': 'g:PesarattuPrepUI'})
endfunc

let s:aragunduPath = expand('<sfile>:h') . '/../node_modules/aragundu/aragundu.js' 
let s:aragunduCommand = 'node ' . s:aragunduPath . ' rcPath=' . g:pesarattu#rc . ' port=' . g:pesarattu#socketPort . ' > ' . g:pesarattu#aragundu#logs

call s:PesarattuEchom ('raising aragundu server with: ' . s:aragunduCommand)
" let s:aragundu = job_start(s:aragunduCommand)

" --------------------------------
"  Expose our commands to the user
" --------------------------------
command! PesarattuStart call Pesarattu#connect()
command! PesarattuStop call PesarattuBurn()
command! PesarattuBPadd call PesarattuSetBreakPoint()

PesarattuStart
