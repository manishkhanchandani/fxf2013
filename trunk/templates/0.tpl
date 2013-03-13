<chart>
symbol=AUDJPY
period=1
leftpos=40500
digits=3
scale=8
graph=1
fore=0
grid=1
volume=0
scroll=1
shift=1
ohlc=1
askline=0
days=0
descriptions=0
shift_size=20
fixed_pos=0
window_left=22
window_top=22
window_right=755
window_bottom=298
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
height=129
<indicator>
name=main
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=cu_macd_strength
flags=339
window_num=0
<inputs>
FastEMA=12
SlowEMA=26
SignalSMA=9
</inputs>
</expert>
shift_0=0
draw_0=0
color_0=12632256
style_0=0
weight_0=2
shift_1=0
draw_1=0
color_1=255
style_1=0
weight_1=0
shift_2=0
draw_2=12
color_2=0
style_2=0
weight_2=0
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
<indicator>
name=Custom Indicator
<expert>
name=3_Level_ZZ_Semafor
flags=339
window_num=0
<inputs>
Period1=5.00000000
Period2=13.00000000
Period3=34.00000000
Dev_Step_1=1,3
Dev_Step_2=8,5
Dev_Step_3=21,12
Symbol_1_Kod=140
Symbol_2_Kod=141
Symbol_3_Kod=142
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=1993170
style_0=0
weight_0=1
arrow_0=140
shift_1=0
draw_1=3
color_1=1993170
style_1=0
weight_1=1
arrow_1=140
shift_2=0
draw_2=3
color_2=8721863
style_2=0
weight_2=2
arrow_2=141
shift_3=0
draw_3=3
color_3=8721863
style_3=0
weight_3=2
arrow_3=141
shift_4=0
draw_4=3
color_4=65535
style_4=0
weight_4=4
arrow_4=142
shift_5=0
draw_5=3
color_5=65535
style_5=0
weight_5=4
arrow_5=142
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=34
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

<window>
height=37
<indicator>
name=Custom Indicator
<expert>
name=4 TF HAS Bar
flags=339
window_num=2
<inputs>
MaMetod=2
MaPeriod=6
MaMetod2=3
MaPeriod2=2
BarWidth=0
BarColorUp=16711680
BarColorDown=255
TextColor=16777215
MaxBars=500
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=255
style_0=0
weight_0=0
arrow_0=110
shift_1=0
draw_1=3
color_1=16711680
style_1=0
weight_1=0
arrow_1=110
shift_2=0
draw_2=3
color_2=255
style_2=0
weight_2=0
arrow_2=110
shift_3=0
draw_3=3
color_3=16711680
style_3=0
weight_3=0
arrow_3=110
shift_4=0
draw_4=3
color_4=255
style_4=0
weight_4=0
arrow_4=110
shift_5=0
draw_5=3
color_5=16711680
style_5=0
weight_5=0
arrow_5=110
shift_6=0
draw_6=3
color_6=255
style_6=0
weight_6=0
arrow_6=110
shift_7=0
draw_7=3
color_7=16711680
style_7=0
weight_7=0
arrow_7=110
min=0.000000
max=5.000000
period_flags=0
show_data=1
<object>
type=21
object_name=FF_228_0_M1
period_flags=0
create_time=1361642644
description=M1
color=16777215
font=Arial
fontsize=8
angle=0
background=0
time_0=1361552520
value_0=1.200000
</object>
<object>
type=21
object_name=FF_228_1_M5
period_flags=0
create_time=1361642644
description=M5
color=16777215
font=Arial
fontsize=8
angle=0
background=0
time_0=1361552520
value_0=2.200000
</object>
<object>
type=21
object_name=FF_228_2_M15
period_flags=0
create_time=1361642644
description=M15
color=16777215
font=Arial
fontsize=8
angle=0
background=0
time_0=1361552520
value_0=3.200000
</object>
<object>
type=21
object_name=FF_228_3_M30
period_flags=0
create_time=1361642644
description=M30
color=16777215
font=Arial
fontsize=8
angle=0
background=0
time_0=1361552520
value_0=4.200000
</object>
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=4 TF HAS Bar2
flags=339
window_num=2
<inputs>
MaMetod=2
MaPeriod=6
MaMetod2=3
MaPeriod2=2
BarWidth=0
UpBarColor=16711680
DownBarColor=255
MaxBars=500
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=16711680
style_0=0
weight_0=0
arrow_0=112
shift_1=0
draw_1=3
color_1=255
style_1=0
weight_1=0
arrow_1=112
shift_2=0
draw_2=3
color_2=16711680
style_2=0
weight_2=0
arrow_2=112
shift_3=0
draw_3=3
color_3=255
style_3=0
weight_3=0
arrow_3=112
shift_4=0
draw_4=3
color_4=16711680
style_4=0
weight_4=0
arrow_4=112
shift_5=0
draw_5=3
color_5=255
style_5=0
weight_5=0
arrow_5=112
shift_6=0
draw_6=3
color_6=16711680
style_6=0
weight_6=0
arrow_6=112
shift_7=0
draw_7=3
color_7=255
style_7=0
weight_7=0
arrow_7=112
min=0.000000
max=5.000000
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=50
<indicator>
name=Custom Indicator
<expert>
name=cuMACD
flags=339
window_num=3
<inputs>
FastEMA=12
SlowEMA=26
SignalSMA=9
</inputs>
</expert>
shift_0=0
draw_0=2
color_0=12632256
style_0=0
weight_0=2
shift_1=0
draw_1=0
color_1=255
style_1=0
weight_1=0
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=50
<indicator>
name=Custom Indicator
<expert>
name=cuMACD2
flags=339
window_num=4
<inputs>
FastEMA=12
SlowEMA=26
SignalSMA=9
</inputs>
</expert>
shift_0=0
draw_0=2
color_0=12632256
style_0=0
weight_0=2
shift_1=0
draw_1=0
color_1=255
style_1=0
weight_1=0
period_flags=0
show_data=1
</indicator>
</window>
</chart>
