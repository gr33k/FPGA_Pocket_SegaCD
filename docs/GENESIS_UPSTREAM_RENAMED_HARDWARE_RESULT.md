# Genesis upstream versus renamed hardware result

## Upstream test
- core appears: yes
- ROM browser opens: yes
- ROM visible: yes
- ROM loads: yes
- video appears: yes
- audio present: yes
- controls respond: yes
- Pocket core menu remains accessible: yes
- black screen: no
- freeze: no
- reset loop: no
- return to menu: no
- ROM filename: Sonic the Hedgehog

## Renamed test
- core appears: yes
- ROM browser opens: yes
- ROM visible: yes
- ROM loads: yes
- video appears: yes
- audio present: yes
- controls respond: yes
- Pocket core menu remains accessible: yes
- black screen: no
- freeze: no
- reset loop: no
- return to menu: no
- ROM filename: Sonic the Hedgehog

## Classification
- BOTH_PASS

Conclusion:
- The earlier black-screen issue was caused by stale and duplicate SD package state, not by the FPGA build, bitstream, or renamed package runtime behavior.
