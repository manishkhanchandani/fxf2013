<chart>
symbol=CADCHF
period=43200
leftpos=20
digits=5
scale=8
graph=1
fore=0
grid=0
volume=0
scroll=1
shift=1
ohlc=1
one_click=0
askline=1
days=0
descriptions=0
shift_size=20
fixed_pos=0
window_left=0
window_top=0
window_right=804
window_bottom=266
window_type=3
background_color=0
foreground_color=16777215
barup_color=65280
bardown_color=65280
bullcandle_color=0
bearcandle_color=16777215
chartline_color=65280
volumes_color=3329330
grid_color=10061943
askline_color=255
stops_color=255

<window>
height=138
<indicator>
name=main
</indicator>
<indicator>
name=Bollinger Bands
period=20
shift=0
deviations=2
apply=0
color=7451452
style=0
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=Heiken_Ashi_Smoothed
flags=339
window_num=0
<inputs>
MaMetod=2
MaPeriod=6
MaMetod2=3
MaPeriod2=2
</inputs>
</expert>
shift_0=0
draw_0=2
color_0=255
style_0=0
weight_0=1
shift_1=0
draw_1=2
color_1=16711680
style_1=0
weight_1=1
shift_2=0
draw_2=2
color_2=255
style_2=0
weight_2=2
shift_3=0
draw_3=2
color_3=16711680
style_3=0
weight_3=2
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=24
<indicator>
name=Stochastic Oscillator
kperiod=14
dperiod=3
slowing=3
method=0
apply=0
color=11186720
style=0
weight=1
color2=255
style2=2
weight2=1
min=0.000000
max=100.000000
levels_color=12632256
levels_style=2
levels_weight=1
level_0=20.0000
level_1=80.0000
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=38
<indicator>
name=MACD
fast_ema=12
slow_ema=26
macd_sma=9
apply=0
color=12632256
style=0
weight=1
signal_color=255
signal_style=2
signal_weight=1
period_flags=0
show_data=1
</indicator>
</window>
</chart>
