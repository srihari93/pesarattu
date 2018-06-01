
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
let s:aragunduURL = g:pesarattu#socketURL . ':' . g:pesarattu#socketPort
echom s:aragunduURL

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
  call ch_logfile('pesarattu-aragundu-comm.log', 'w')
  let s:aragunduChannel = ch_open(s:aragunduURL, {'callback':'g:PesarattuAragunduHandler'})
  if( ch_status(s:aragunduChannel) ==# 'open')
    echom 'Pesarattu: failed to connnect to server, aragundu: ' . s:aragunduChannel
    return
  endif
  echom 'Pesarattu: connected to server, aragundu: ' . s:aragunduChannel
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

func! PesarattuLoadBreakPoints()

endfunc

func! PesarattuDebug(instance)
  call ch_sendexpr(s:aragunduChannel, {'attu':'debug' , 'instance':a:instance})
endfunc

let s:aragunduPath = expand('<sfile>:h') . '/../node_modules/aragundu/aragundu.js' 
let s:aragunduCommand = 'node ' . s:aragunduPath . ' rcPath=' . g:pesarattu#rc . ' port=' . g:pesarattu#socketPort . ' > ' . g:pesarattu#aragundu#logs

echom s:aragunduCommand

" --------------------------------
"  Expose our commands to the user
" --------------------------------
command! PesarattuStart call Pesarattu#connect()
command! PesarattuBurn call PesarattuBurn()

PesarattuStart
