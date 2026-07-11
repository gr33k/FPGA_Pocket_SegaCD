# MegaCD Pocket live run recovery

- branch: `feature/megacd-bringup`
- recovery state: `FIT_COMPLETED`
- live Quartus processes: none found during recovery poll
- live Docker Quartus containers: none running during recovery poll
- duplicate job avoidance: do not relaunch fit for this exact tree unless source or constraints change
- prior Quartus run evidence:
- map host/container from `ap_core.flow.rpt`: `33309dc57045`
- fit host/container from `ap_core.flow.rpt`: `1842505aebd6`
- current runner shell session: exited before harvest
- result source of truth: `build/megacd_pocket_fit_probe/output_files/ap_core.fit.summary` and `ap_core.flow.rpt`
