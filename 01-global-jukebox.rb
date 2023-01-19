# Decibels Sonification Challenge #1

rituals = 10
dance = 10
passive = 2
entertain = 0
signaling = 1

load_sample :drum_heavy_kick

notes = [:E4, :Ds4, :E4, :Fs5, :Gs5, :A4, :B4, :Cs5, :B4, :Fs4, :Ds5, :Cs5]

##| # use this function to translate data values
def normalise(x, xmin, xmax, ymin, ymax)
  xrange = xmax - xmin
  yrange = ymax - ymin
  ymin + (x - xmin) * (yrange.to_f / xrange)
end

use_bpm normalise(dance,1,12,50,100)

##| # setup drums and sync everything to this
##| # TODO: make the beat more interesting using some randomization for hi hats or something
live_loop :drums do
  sample :elec_soft_kick, rate: 0.5, amp: 2
  sleep 1
  sample :elec_snare, amp: 0.5, rate: 0.7
  sleep 1
end

live_loop :perc do
sample :elec_tick, amp: 0.7 if one_in(4)
sleep 0.25
end

#SYNTH ARP MAPPED TO RITUALS
#REVERB MAPPED TO PASSIVE LISTENING
with_fx :reverb, mix: normalise(passive,0,10,0,1) do
live_loop :synths do
use_synth :tri
use_synth_defaults amp: 0.6, mod_range: 5, cutoff: 70, attack: 0.03, release: 1
choose random notes from array above. Notes play more frequently for higher ritual values
play choose(notes), amp: 0.2 if one_in(normalise(rituals,1,15,10,1))
sleep 0.25
end
end

##| # BASS MAPPED TO SIGNALING
##| # GUITAR SAMPLE MAPPED TO SELF ENTERTAING
live_loop :basses do
  sync :drums
  use_synth_defaults
  #sample :guit_e_slide, amp: normalise(entertain,0,9,0.1,1.5)
  synth :pulse , amp: 0.5, attack:  0.6, note: :E2, release: 5, cutoff: normalise(signaling,0,5,15,80)
  sleep 2
  synth :pulse, amp: 0.5, attack:  0.6, note: :E2, release: 5, cutoff: normalise(signaling,0,5,15,80)
  sleep 2
end
