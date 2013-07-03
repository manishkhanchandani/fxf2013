<chart>
comment= D1 - brown
symbol=AUDUSD
period=240
leftpos=2756
digits=4
scale=4
graph=1
fore=0
grid=0
volume=0
scroll=1
shift=1
ohlc=0
askline=1
days=0
descriptions=0
shift_size=50
fixed_pos=0
window_left=633
window_top=0
window_right=1266
window_bottom=264
window_type=3
background_color=0
foreground_color=16777215
barup_color=65280
bardown_color=65280
bullcandle_color=0
bearcandle_color=16777215
chartline_color=-1
volumes_color=3329330
grid_color=10061943
askline_color=255
stops_color=255

<window>
height=74
<indicator>
name=main
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=Ind-Fractals-1
flags=339
window_num=0
<inputs>
Comm=1
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=255
style_0=0
weight_0=0
arrow_0=217
shift_1=0
draw_1=3
color_1=255
style_1=0
weight_1=0
arrow_1=218
shift_2=0
draw_2=3
color_2=16711680
style_2=0
weight_2=0
arrow_2=217
shift_3=0
draw_3=3
color_3=16711680
style_3=0
weight_3=0
arrow_3=218
shift_4=0
draw_4=3
color_4=65280
style_4=0
weight_4=0
arrow_4=217
shift_5=0
draw_5=3
color_5=65280
style_5=0
weight_5=0
arrow_5=218
shift_6=0
draw_6=3
color_6=2970272
style_6=0
weight_6=0
arrow_6=217
shift_7=0
draw_7=3
color_7=2970272
style_7=0
weight_7=0
arrow_7=218
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=NonLagMA_v7_M
flags=339
window_num=0
<inputs>
Price=0
Length=30
Displace=0
PctFilter=0.25000000
Color=1
ColorBarBack=1
Deviation=0.00000000
SoundAlertMode=0
</inputs>
</expert>
shift_0=0
draw_0=0
color_0=65535
style_0=0
weight_0=4
shift_1=0
draw_1=0
color_1=65280
style_1=0
weight_1=4
shift_2=0
draw_2=0
color_2=255
style_2=0
weight_2=4
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=50
<indicator>
name=Commodity Channel Index
period=50
apply=5
color=16711680
style=0
weight=1
min=-300.000000
max=300.000000
levels_color=4163021
levels_style=2
levels_weight=1
level_0=0.0000
level_1=100.0000
level_2=-100.0000
period_flags=0
show_data=1
</indicator>
<indicator>
name=Commodity Channel Index
period=25
apply=5
color=255
style=0
weight=1
min=-300.000000
max=300.000000
levels_color=4163021
levels_style=2
levels_weight=1
level_0=0.0000
level_1=100.0000
level_2=-100.0000
period_flags=0
show_data=1
</indicator>
</window>
</chart>
