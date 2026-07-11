# Genesis upstream renamed package diff

- active upstream core: `/Volumes/ANALOGUE/Cores/ericlewis.Genesis`
- active renamed core: `/Volumes/ANALOGUE/Cores/Gr33k.SegaCD`
- expected legitimate differences: directory name and selected `core.json` branding fields

## Functional metadata hashes
### audio.json
61d2263613a47f29f19bc0d19c32a19c2dbd0872bccc29f833c3de44f4830add  /Volumes/ANALOGUE/Cores/ericlewis.Genesis/audio.json
61d2263613a47f29f19bc0d19c32a19c2dbd0872bccc29f833c3de44f4830add  /Volumes/ANALOGUE/Cores/Gr33k.SegaCD/audio.json

### data.json
ea038c34e9d29a1cd5a2260cab005b69e85e8dc6a529ebed50dfa165b7c10de9  /Volumes/ANALOGUE/Cores/ericlewis.Genesis/data.json
ea038c34e9d29a1cd5a2260cab005b69e85e8dc6a529ebed50dfa165b7c10de9  /Volumes/ANALOGUE/Cores/Gr33k.SegaCD/data.json

### input.json
0e6b573b3e4c099ae9ce704dbb5c3cfeb4ce918d9f49403585c450c078a07d90  /Volumes/ANALOGUE/Cores/ericlewis.Genesis/input.json
0e6b573b3e4c099ae9ce704dbb5c3cfeb4ce918d9f49403585c450c078a07d90  /Volumes/ANALOGUE/Cores/Gr33k.SegaCD/input.json

### interact.json
1dd903bf7f5f5a9ee3d5aa0e0a1dc1381f50656b37af2b4ccd826f207fb13f90  /Volumes/ANALOGUE/Cores/ericlewis.Genesis/interact.json
1dd903bf7f5f5a9ee3d5aa0e0a1dc1381f50656b37af2b4ccd826f207fb13f90  /Volumes/ANALOGUE/Cores/Gr33k.SegaCD/interact.json

### variants.json
20435a5a696085a01110c617f93f25a7cc9c403ea5fa71050fe2d687f2f86162  /Volumes/ANALOGUE/Cores/ericlewis.Genesis/variants.json
20435a5a696085a01110c617f93f25a7cc9c403ea5fa71050fe2d687f2f86162  /Volumes/ANALOGUE/Cores/Gr33k.SegaCD/variants.json

### video.json
ac3a85336cfbf8fe33118f047aad87b0a296c443a5cd4427b8f59fe8cf15709a  /Volumes/ANALOGUE/Cores/ericlewis.Genesis/video.json
ac3a85336cfbf8fe33118f047aad87b0a296c443a5cd4427b8f59fe8cf15709a  /Volumes/ANALOGUE/Cores/Gr33k.SegaCD/video.json

### bitstream.rbf_r
3867ec0207fdcb741a51c01b905ab8ae2217bd31274a991d1392f070cb795689  /Volumes/ANALOGUE/Cores/ericlewis.Genesis/bitstream.rbf_r
3867ec0207fdcb741a51c01b905ab8ae2217bd31274a991d1392f070cb795689  /Volumes/ANALOGUE/Cores/Gr33k.SegaCD/bitstream.rbf_r

## Full diff
diff -ru /Volumes/ANALOGUE/Cores/ericlewis.Genesis/core.json /Volumes/ANALOGUE/Cores/Gr33k.SegaCD/core.json
--- /Volumes/ANALOGUE/Cores/ericlewis.Genesis/core.json	2026-07-06 23:13:09
+++ /Volumes/ANALOGUE/Cores/Gr33k.SegaCD/core.json	2026-07-10 17:57:41
@@ -2,11 +2,13 @@
     "core": {
         "magic": "APF_VER_1",
         "metadata": {
-            "platform_ids": ["genesis"],
-            "shortname": "Genesis",
-            "description": "Sega Genesis, known as the Mega Drive outside North America, is a 16-bit fourth-generation home video game console developed and sold by Sega.",
-            "author": "ericlewis",
-            "url": "https://github.com/ericlewis/openfpga-genesis",
+            "platform_ids": [
+                "genesis"
+            ],
+            "shortname": "SegaCD",
+            "description": "Genesis FPGA core with future Sega CD and 32X expansion.",
+            "author": "Gr33k",
+            "url": "https://github.com/gr33k/FPGA_Pocket_SegaCD",
             "version": "0.4.2",
             "date_release": "2022-10-08"
         },
