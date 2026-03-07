
overlap:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64
    1004:	48 83 ec 08          	sub    rsp,0x8
    1008:	48 8b 05 d9 2f 00 00 	mov    rax,QWORD PTR [rip+0x2fd9]        # 3fe8 <__gmon_start__@Base>
    100f:	48 85 c0             	test   rax,rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	call   rax
    1016:	48 83 c4 08          	add    rsp,0x8
    101a:	c3                   	ret

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	ff 35 4a 2f 00 00    	push   QWORD PTR [rip+0x2f4a]        # 3f70 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	ff 25 4c 2f 00 00    	jmp    QWORD PTR [rip+0x2f4c]        # 3f78 <_GLOBAL_OFFSET_TABLE_+0x10>
    102c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
    1030:	f3 0f 1e fa          	endbr64
    1034:	68 00 00 00 00       	push   0x0
    1039:	e9 e2 ff ff ff       	jmp    1020 <_init+0x20>
    103e:	66 90                	xchg   ax,ax
    1040:	f3 0f 1e fa          	endbr64
    1044:	68 01 00 00 00       	push   0x1
    1049:	e9 d2 ff ff ff       	jmp    1020 <_init+0x20>
    104e:	66 90                	xchg   ax,ax
    1050:	f3 0f 1e fa          	endbr64
    1054:	68 02 00 00 00       	push   0x2
    1059:	e9 c2 ff ff ff       	jmp    1020 <_init+0x20>
    105e:	66 90                	xchg   ax,ax
    1060:	f3 0f 1e fa          	endbr64
    1064:	68 03 00 00 00       	push   0x3
    1069:	e9 b2 ff ff ff       	jmp    1020 <_init+0x20>
    106e:	66 90                	xchg   ax,ax
    1070:	f3 0f 1e fa          	endbr64
    1074:	68 04 00 00 00       	push   0x4
    1079:	e9 a2 ff ff ff       	jmp    1020 <_init+0x20>
    107e:	66 90                	xchg   ax,ax
    1080:	f3 0f 1e fa          	endbr64
    1084:	68 05 00 00 00       	push   0x5
    1089:	e9 92 ff ff ff       	jmp    1020 <_init+0x20>
    108e:	66 90                	xchg   ax,ax
    1090:	f3 0f 1e fa          	endbr64
    1094:	68 06 00 00 00       	push   0x6
    1099:	e9 82 ff ff ff       	jmp    1020 <_init+0x20>
    109e:	66 90                	xchg   ax,ax
    10a0:	f3 0f 1e fa          	endbr64
    10a4:	68 07 00 00 00       	push   0x7
    10a9:	e9 72 ff ff ff       	jmp    1020 <_init+0x20>
    10ae:	66 90                	xchg   ax,ax
    10b0:	f3 0f 1e fa          	endbr64
    10b4:	68 08 00 00 00       	push   0x8
    10b9:	e9 62 ff ff ff       	jmp    1020 <_init+0x20>
    10be:	66 90                	xchg   ax,ax
    10c0:	f3 0f 1e fa          	endbr64
    10c4:	68 09 00 00 00       	push   0x9
    10c9:	e9 52 ff ff ff       	jmp    1020 <_init+0x20>
    10ce:	66 90                	xchg   ax,ax
    10d0:	f3 0f 1e fa          	endbr64
    10d4:	68 0a 00 00 00       	push   0xa
    10d9:	e9 42 ff ff ff       	jmp    1020 <_init+0x20>
    10de:	66 90                	xchg   ax,ax

Disassembly of section .plt.got:

00000000000010e0 <__cxa_finalize@plt>:
    10e0:	f3 0f 1e fa          	endbr64
    10e4:	ff 25 0e 2f 00 00    	jmp    QWORD PTR [rip+0x2f0e]        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    10ea:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

Disassembly of section .plt.sec:

00000000000010f0 <free@plt>:
    10f0:	f3 0f 1e fa          	endbr64
    10f4:	ff 25 86 2e 00 00    	jmp    QWORD PTR [rip+0x2e86]        # 3f80 <free@GLIBC_2.2.5>
    10fa:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000001100 <puts@plt>:
    1100:	f3 0f 1e fa          	endbr64
    1104:	ff 25 7e 2e 00 00    	jmp    QWORD PTR [rip+0x2e7e]        # 3f88 <puts@GLIBC_2.2.5>
    110a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000001110 <fread@plt>:
    1110:	f3 0f 1e fa          	endbr64
    1114:	ff 25 76 2e 00 00    	jmp    QWORD PTR [rip+0x2e76]        # 3f90 <fread@GLIBC_2.2.5>
    111a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000001120 <fclose@plt>:
    1120:	f3 0f 1e fa          	endbr64
    1124:	ff 25 6e 2e 00 00    	jmp    QWORD PTR [rip+0x2e6e]        # 3f98 <fclose@GLIBC_2.2.5>
    112a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000001130 <__stack_chk_fail@plt>:
    1130:	f3 0f 1e fa          	endbr64
    1134:	ff 25 66 2e 00 00    	jmp    QWORD PTR [rip+0x2e66]        # 3fa0 <__stack_chk_fail@GLIBC_2.4>
    113a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000001140 <printf@plt>:
    1140:	f3 0f 1e fa          	endbr64
    1144:	ff 25 5e 2e 00 00    	jmp    QWORD PTR [rip+0x2e5e]        # 3fa8 <printf@GLIBC_2.2.5>
    114a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000001150 <getchar@plt>:
    1150:	f3 0f 1e fa          	endbr64
    1154:	ff 25 56 2e 00 00    	jmp    QWORD PTR [rip+0x2e56]        # 3fb0 <getchar@GLIBC_2.2.5>
    115a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000001160 <malloc@plt>:
    1160:	f3 0f 1e fa          	endbr64
    1164:	ff 25 4e 2e 00 00    	jmp    QWORD PTR [rip+0x2e4e]        # 3fb8 <malloc@GLIBC_2.2.5>
    116a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000001170 <setvbuf@plt>:
    1170:	f3 0f 1e fa          	endbr64
    1174:	ff 25 46 2e 00 00    	jmp    QWORD PTR [rip+0x2e46]        # 3fc0 <setvbuf@GLIBC_2.2.5>
    117a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000001180 <fopen@plt>:
    1180:	f3 0f 1e fa          	endbr64
    1184:	ff 25 3e 2e 00 00    	jmp    QWORD PTR [rip+0x2e3e]        # 3fc8 <fopen@GLIBC_2.2.5>
    118a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000001190 <__isoc99_scanf@plt>:
    1190:	f3 0f 1e fa          	endbr64
    1194:	ff 25 36 2e 00 00    	jmp    QWORD PTR [rip+0x2e36]        # 3fd0 <__isoc99_scanf@GLIBC_2.7>
    119a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

Disassembly of section .text:

00000000000011a0 <_start>:
    11a0:	f3 0f 1e fa          	endbr64
    11a4:	31 ed                	xor    ebp,ebp
    11a6:	49 89 d1             	mov    r9,rdx
    11a9:	5e                   	pop    rsi
    11aa:	48 89 e2             	mov    rdx,rsp
    11ad:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
    11b1:	50                   	push   rax
    11b2:	54                   	push   rsp
    11b3:	45 31 c0             	xor    r8d,r8d
    11b6:	31 c9                	xor    ecx,ecx
    11b8:	48 8d 3d d4 06 00 00 	lea    rdi,[rip+0x6d4]        # 1893 <main>
    11bf:	ff 15 13 2e 00 00    	call   QWORD PTR [rip+0x2e13]        # 3fd8 <__libc_start_main@GLIBC_2.34>
    11c5:	f4                   	hlt
    11c6:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    11cd:	00 00 00 

00000000000011d0 <deregister_tm_clones>:
    11d0:	48 8d 3d 39 2e 00 00 	lea    rdi,[rip+0x2e39]        # 4010 <__TMC_END__>
    11d7:	48 8d 05 32 2e 00 00 	lea    rax,[rip+0x2e32]        # 4010 <__TMC_END__>
    11de:	48 39 f8             	cmp    rax,rdi
    11e1:	74 15                	je     11f8 <deregister_tm_clones+0x28>
    11e3:	48 8b 05 f6 2d 00 00 	mov    rax,QWORD PTR [rip+0x2df6]        # 3fe0 <_ITM_deregisterTMCloneTable@Base>
    11ea:	48 85 c0             	test   rax,rax
    11ed:	74 09                	je     11f8 <deregister_tm_clones+0x28>
    11ef:	ff e0                	jmp    rax
    11f1:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    11f8:	c3                   	ret
    11f9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001200 <register_tm_clones>:
    1200:	48 8d 3d 09 2e 00 00 	lea    rdi,[rip+0x2e09]        # 4010 <__TMC_END__>
    1207:	48 8d 35 02 2e 00 00 	lea    rsi,[rip+0x2e02]        # 4010 <__TMC_END__>
    120e:	48 29 fe             	sub    rsi,rdi
    1211:	48 89 f0             	mov    rax,rsi
    1214:	48 c1 ee 3f          	shr    rsi,0x3f
    1218:	48 c1 f8 03          	sar    rax,0x3
    121c:	48 01 c6             	add    rsi,rax
    121f:	48 d1 fe             	sar    rsi,1
    1222:	74 14                	je     1238 <register_tm_clones+0x38>
    1224:	48 8b 05 c5 2d 00 00 	mov    rax,QWORD PTR [rip+0x2dc5]        # 3ff0 <_ITM_registerTMCloneTable@Base>
    122b:	48 85 c0             	test   rax,rax
    122e:	74 08                	je     1238 <register_tm_clones+0x38>
    1230:	ff e0                	jmp    rax
    1232:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    1238:	c3                   	ret
    1239:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001240 <__do_global_dtors_aux>:
    1240:	f3 0f 1e fa          	endbr64
    1244:	80 3d fd 2d 00 00 00 	cmp    BYTE PTR [rip+0x2dfd],0x0        # 4048 <completed.0>
    124b:	75 2b                	jne    1278 <__do_global_dtors_aux+0x38>
    124d:	55                   	push   rbp
    124e:	48 83 3d a2 2d 00 00 	cmp    QWORD PTR [rip+0x2da2],0x0        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1255:	00 
    1256:	48 89 e5             	mov    rbp,rsp
    1259:	74 0c                	je     1267 <__do_global_dtors_aux+0x27>
    125b:	48 8b 3d a6 2d 00 00 	mov    rdi,QWORD PTR [rip+0x2da6]        # 4008 <__dso_handle>
    1262:	e8 79 fe ff ff       	call   10e0 <__cxa_finalize@plt>
    1267:	e8 64 ff ff ff       	call   11d0 <deregister_tm_clones>
    126c:	c6 05 d5 2d 00 00 01 	mov    BYTE PTR [rip+0x2dd5],0x1        # 4048 <completed.0>
    1273:	5d                   	pop    rbp
    1274:	c3                   	ret
    1275:	0f 1f 00             	nop    DWORD PTR [rax]
    1278:	c3                   	ret
    1279:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001280 <frame_dummy>:
    1280:	f3 0f 1e fa          	endbr64
    1284:	e9 77 ff ff ff       	jmp    1200 <register_tm_clones>

0000000000001289 <is_valid_index>:
    1289:	f3 0f 1e fa          	endbr64
    128d:	55                   	push   rbp
    128e:	48 89 e5             	mov    rbp,rsp
    1291:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
    1294:	83 7d fc 00          	cmp    DWORD PTR [rbp-0x4],0x0
    1298:	78 18                	js     12b2 <is_valid_index+0x29>
    129a:	83 7d fc 0b          	cmp    DWORD PTR [rbp-0x4],0xb
    129e:	7f 12                	jg     12b2 <is_valid_index+0x29>
    12a0:	8b 05 ba 2d 00 00    	mov    eax,DWORD PTR [rip+0x2dba]        # 4060 <counter>
    12a6:	39 45 fc             	cmp    DWORD PTR [rbp-0x4],eax
    12a9:	7d 07                	jge    12b2 <is_valid_index+0x29>
    12ab:	b8 01 00 00 00       	mov    eax,0x1
    12b0:	eb 05                	jmp    12b7 <is_valid_index+0x2e>
    12b2:	b8 00 00 00 00       	mov    eax,0x0
    12b7:	83 e0 01             	and    eax,0x1
    12ba:	5d                   	pop    rbp
    12bb:	c3                   	ret

00000000000012bc <is_valid_chunk_size>:
    12bc:	f3 0f 1e fa          	endbr64
    12c0:	55                   	push   rbp
    12c1:	48 89 e5             	mov    rbp,rsp
    12c4:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
    12c7:	83 7d fc 00          	cmp    DWORD PTR [rbp-0x4],0x0
    12cb:	78 10                	js     12dd <is_valid_chunk_size+0x21>
    12cd:	81 7d fc 20 04 00 00 	cmp    DWORD PTR [rbp-0x4],0x420
    12d4:	7f 07                	jg     12dd <is_valid_chunk_size+0x21>
    12d6:	b8 01 00 00 00       	mov    eax,0x1
    12db:	eb 05                	jmp    12e2 <is_valid_chunk_size+0x26>
    12dd:	b8 00 00 00 00       	mov    eax,0x0
    12e2:	83 e0 01             	and    eax,0x1
    12e5:	5d                   	pop    rbp
    12e6:	c3                   	ret

00000000000012e7 <read_flag>:
    12e7:	f3 0f 1e fa          	endbr64
    12eb:	55                   	push   rbp
    12ec:	48 89 e5             	mov    rbp,rsp
    12ef:	48 83 ec 20          	sub    rsp,0x20
    12f3:	48 8d 05 0e 0d 00 00 	lea    rax,[rip+0xd0e]        # 2008 <_IO_stdin_used+0x8>
    12fa:	48 89 c6             	mov    rsi,rax
    12fd:	48 8d 05 06 0d 00 00 	lea    rax,[rip+0xd06]        # 200a <_IO_stdin_used+0xa>
    1304:	48 89 c7             	mov    rdi,rax
    1307:	e8 74 fe ff ff       	call   1180 <fopen@plt>
    130c:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
    1310:	48 83 7d e8 00       	cmp    QWORD PTR [rbp-0x18],0x0
    1315:	75 16                	jne    132d <read_flag+0x46>
    1317:	48 8d 05 f5 0c 00 00 	lea    rax,[rip+0xcf5]        # 2013 <_IO_stdin_used+0x13>
    131e:	48 89 c7             	mov    rdi,rax
    1321:	b8 00 00 00 00       	mov    eax,0x0
    1326:	e8 15 fe ff ff       	call   1140 <printf@plt>
    132b:	eb 6d                	jmp    139a <read_flag+0xb3>
    132d:	bf b1 02 00 00       	mov    edi,0x2b1
    1332:	e8 29 fe ff ff       	call   1160 <malloc@plt>
    1337:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
    133b:	48 83 7d f0 00       	cmp    QWORD PTR [rbp-0x10],0x0
    1340:	75 1d                	jne    135f <read_flag+0x78>
    1342:	48 8d 05 e3 0c 00 00 	lea    rax,[rip+0xce3]        # 202c <_IO_stdin_used+0x2c>
    1349:	48 89 c7             	mov    rdi,rax
    134c:	e8 af fd ff ff       	call   1100 <puts@plt>
    1351:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
    1355:	48 89 c7             	mov    rdi,rax
    1358:	e8 c3 fd ff ff       	call   1120 <fclose@plt>
    135d:	eb 3b                	jmp    139a <read_flag+0xb3>
    135f:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
    1363:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
    1367:	48 89 d1             	mov    rcx,rdx
    136a:	ba b0 02 00 00       	mov    edx,0x2b0
    136f:	be 01 00 00 00       	mov    esi,0x1
    1374:	48 89 c7             	mov    rdi,rax
    1377:	e8 94 fd ff ff       	call   1110 <fread@plt>
    137c:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    1380:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
    1384:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    1388:	48 01 d0             	add    rax,rdx
    138b:	c6 00 00             	mov    BYTE PTR [rax],0x0
    138e:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
    1392:	48 89 c7             	mov    rdi,rax
    1395:	e8 86 fd ff ff       	call   1120 <fclose@plt>
    139a:	c9                   	leave
    139b:	c3                   	ret

000000000000139c <clear_memory>:
    139c:	f3 0f 1e fa          	endbr64
    13a0:	55                   	push   rbp
    13a1:	48 89 e5             	mov    rbp,rsp
    13a4:	48 83 ec 10          	sub    rsp,0x10
    13a8:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    13af:	00 00 
    13b1:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    13b5:	31 c0                	xor    eax,eax
    13b7:	48 8d 05 82 0c 00 00 	lea    rax,[rip+0xc82]        # 2040 <_IO_stdin_used+0x40>
    13be:	48 89 c7             	mov    rdi,rax
    13c1:	e8 3a fd ff ff       	call   1100 <puts@plt>
    13c6:	48 8d 45 f0          	lea    rax,[rbp-0x10]
    13ca:	48 89 c6             	mov    rsi,rax
    13cd:	48 8d 05 80 0c 00 00 	lea    rax,[rip+0xc80]        # 2054 <_IO_stdin_used+0x54>
    13d4:	48 89 c7             	mov    rdi,rax
    13d7:	b8 00 00 00 00       	mov    eax,0x0
    13dc:	e8 af fd ff ff       	call   1190 <__isoc99_scanf@plt>
    13e1:	89 45 f4             	mov    DWORD PTR [rbp-0xc],eax
    13e4:	83 7d f4 ff          	cmp    DWORD PTR [rbp-0xc],0xffffffff
    13e8:	74 06                	je     13f0 <clear_memory+0x54>
    13ea:	83 7d f4 00          	cmp    DWORD PTR [rbp-0xc],0x0
    13ee:	75 11                	jne    1401 <clear_memory+0x65>
    13f0:	48 8d 05 60 0c 00 00 	lea    rax,[rip+0xc60]        # 2057 <_IO_stdin_used+0x57>
    13f7:	48 89 c7             	mov    rdi,rax
    13fa:	e8 01 fd ff ff       	call   1100 <puts@plt>
    13ff:	eb 79                	jmp    147a <clear_memory+0xde>
    1401:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
    1404:	89 c7                	mov    edi,eax
    1406:	e8 7e fe ff ff       	call   1289 <is_valid_index>
    140b:	83 f0 01             	xor    eax,0x1
    140e:	84 c0                	test   al,al
    1410:	74 11                	je     1423 <clear_memory+0x87>
    1412:	48 8d 05 54 0c 00 00 	lea    rax,[rip+0xc54]        # 206d <_IO_stdin_used+0x6d>
    1419:	48 89 c7             	mov    rdi,rax
    141c:	e8 df fc ff ff       	call   1100 <puts@plt>
    1421:	eb 57                	jmp    147a <clear_memory+0xde>
    1423:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
    1426:	48 98                	cdqe
    1428:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
    142f:	00 
    1430:	48 8d 05 49 2c 00 00 	lea    rax,[rip+0x2c49]        # 4080 <ptr_table>
    1437:	48 8b 04 02          	mov    rax,QWORD PTR [rdx+rax*1]
    143b:	48 89 c7             	mov    rdi,rax
    143e:	e8 ad fc ff ff       	call   10f0 <free@plt>
    1443:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
    1446:	48 98                	cdqe
    1448:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
    144f:	00 
    1450:	48 8d 05 29 2c 00 00 	lea    rax,[rip+0x2c29]        # 4080 <ptr_table>
    1457:	48 c7 04 02 00 00 00 	mov    QWORD PTR [rdx+rax*1],0x0
    145e:	00 
    145f:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
    1462:	48 98                	cdqe
    1464:	48 8d 14 85 00 00 00 	lea    rdx,[rax*4+0x0]
    146b:	00 
    146c:	48 8d 05 6d 2c 00 00 	lea    rax,[rip+0x2c6d]        # 40e0 <ptr_size_table>
    1473:	c7 04 02 00 00 00 00 	mov    DWORD PTR [rdx+rax*1],0x0
    147a:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    147e:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    1485:	00 00 
    1487:	74 05                	je     148e <clear_memory+0xf2>
    1489:	e8 a2 fc ff ff       	call   1130 <__stack_chk_fail@plt>
    148e:	c9                   	leave
    148f:	c3                   	ret

0000000000001490 <manage_allocation>:
    1490:	f3 0f 1e fa          	endbr64
    1494:	55                   	push   rbp
    1495:	48 89 e5             	mov    rbp,rsp
    1498:	48 83 ec 20          	sub    rsp,0x20
    149c:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    14a3:	00 00 
    14a5:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    14a9:	31 c0                	xor    eax,eax
    14ab:	8b 05 af 2b 00 00    	mov    eax,DWORD PTR [rip+0x2baf]        # 4060 <counter>
    14b1:	83 f8 0b             	cmp    eax,0xb
    14b4:	7e 14                	jle    14ca <manage_allocation+0x3a>
    14b6:	48 8d 05 cb 0b 00 00 	lea    rax,[rip+0xbcb]        # 2088 <_IO_stdin_used+0x88>
    14bd:	48 89 c7             	mov    rdi,rax
    14c0:	e8 3b fc ff ff       	call   1100 <puts@plt>
    14c5:	e9 d8 00 00 00       	jmp    15a2 <manage_allocation+0x112>
    14ca:	48 8d 05 d6 0b 00 00 	lea    rax,[rip+0xbd6]        # 20a7 <_IO_stdin_used+0xa7>
    14d1:	48 89 c7             	mov    rdi,rax
    14d4:	e8 27 fc ff ff       	call   1100 <puts@plt>
    14d9:	48 8d 45 e8          	lea    rax,[rbp-0x18]
    14dd:	48 89 c6             	mov    rsi,rax
    14e0:	48 8d 05 6d 0b 00 00 	lea    rax,[rip+0xb6d]        # 2054 <_IO_stdin_used+0x54>
    14e7:	48 89 c7             	mov    rdi,rax
    14ea:	b8 00 00 00 00       	mov    eax,0x0
    14ef:	e8 9c fc ff ff       	call   1190 <__isoc99_scanf@plt>
    14f4:	89 45 ec             	mov    DWORD PTR [rbp-0x14],eax
    14f7:	83 7d ec ff          	cmp    DWORD PTR [rbp-0x14],0xffffffff
    14fb:	74 06                	je     1503 <manage_allocation+0x73>
    14fd:	83 7d ec 00          	cmp    DWORD PTR [rbp-0x14],0x0
    1501:	75 14                	jne    1517 <manage_allocation+0x87>
    1503:	48 8d 05 a4 0b 00 00 	lea    rax,[rip+0xba4]        # 20ae <_IO_stdin_used+0xae>
    150a:	48 89 c7             	mov    rdi,rax
    150d:	e8 ee fb ff ff       	call   1100 <puts@plt>
    1512:	e9 8b 00 00 00       	jmp    15a2 <manage_allocation+0x112>
    1517:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
    151a:	89 c7                	mov    edi,eax
    151c:	e8 9b fd ff ff       	call   12bc <is_valid_chunk_size>
    1521:	83 f0 01             	xor    eax,0x1
    1524:	84 c0                	test   al,al
    1526:	74 11                	je     1539 <manage_allocation+0xa9>
    1528:	48 8d 05 93 0b 00 00 	lea    rax,[rip+0xb93]        # 20c2 <_IO_stdin_used+0xc2>
    152f:	48 89 c7             	mov    rdi,rax
    1532:	e8 c9 fb ff ff       	call   1100 <puts@plt>
    1537:	eb 69                	jmp    15a2 <manage_allocation+0x112>
    1539:	8b 45 e8             	mov    eax,DWORD PTR [rbp-0x18]
    153c:	48 98                	cdqe
    153e:	48 89 c7             	mov    rdi,rax
    1541:	e8 1a fc ff ff       	call   1160 <malloc@plt>
    1546:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
    154a:	48 83 7d f0 00       	cmp    QWORD PTR [rbp-0x10],0x0
    154f:	74 50                	je     15a1 <manage_allocation+0x111>
    1551:	8b 05 09 2b 00 00    	mov    eax,DWORD PTR [rip+0x2b09]        # 4060 <counter>
    1557:	48 98                	cdqe
    1559:	48 8d 0c c5 00 00 00 	lea    rcx,[rax*8+0x0]
    1560:	00 
    1561:	48 8d 15 18 2b 00 00 	lea    rdx,[rip+0x2b18]        # 4080 <ptr_table>
    1568:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
    156c:	48 89 04 11          	mov    QWORD PTR [rcx+rdx*1],rax
    1570:	8b 55 e8             	mov    edx,DWORD PTR [rbp-0x18]
    1573:	8b 05 e7 2a 00 00    	mov    eax,DWORD PTR [rip+0x2ae7]        # 4060 <counter>
    1579:	8d 4a 10             	lea    ecx,[rdx+0x10]
    157c:	48 98                	cdqe
    157e:	48 8d 14 85 00 00 00 	lea    rdx,[rax*4+0x0]
    1585:	00 
    1586:	48 8d 05 53 2b 00 00 	lea    rax,[rip+0x2b53]        # 40e0 <ptr_size_table>
    158d:	89 0c 02             	mov    DWORD PTR [rdx+rax*1],ecx
    1590:	8b 05 ca 2a 00 00    	mov    eax,DWORD PTR [rip+0x2aca]        # 4060 <counter>
    1596:	83 c0 01             	add    eax,0x1
    1599:	89 05 c1 2a 00 00    	mov    DWORD PTR [rip+0x2ac1],eax        # 4060 <counter>
    159f:	eb 01                	jmp    15a2 <manage_allocation+0x112>
    15a1:	90                   	nop
    15a2:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    15a6:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    15ad:	00 00 
    15af:	74 05                	je     15b6 <manage_allocation+0x126>
    15b1:	e8 7a fb ff ff       	call   1130 <__stack_chk_fail@plt>
    15b6:	c9                   	leave
    15b7:	c3                   	ret

00000000000015b8 <read_operation>:
    15b8:	f3 0f 1e fa          	endbr64
    15bc:	55                   	push   rbp
    15bd:	48 89 e5             	mov    rbp,rsp
    15c0:	48 83 ec 10          	sub    rsp,0x10
    15c4:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    15cb:	00 00 
    15cd:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    15d1:	31 c0                	xor    eax,eax
    15d3:	48 8d 05 66 0a 00 00 	lea    rax,[rip+0xa66]        # 2040 <_IO_stdin_used+0x40>
    15da:	48 89 c7             	mov    rdi,rax
    15dd:	e8 1e fb ff ff       	call   1100 <puts@plt>
    15e2:	48 8d 45 f0          	lea    rax,[rbp-0x10]
    15e6:	48 89 c6             	mov    rsi,rax
    15e9:	48 8d 05 64 0a 00 00 	lea    rax,[rip+0xa64]        # 2054 <_IO_stdin_used+0x54>
    15f0:	48 89 c7             	mov    rdi,rax
    15f3:	b8 00 00 00 00       	mov    eax,0x0
    15f8:	e8 93 fb ff ff       	call   1190 <__isoc99_scanf@plt>
    15fd:	89 45 f4             	mov    DWORD PTR [rbp-0xc],eax
    1600:	83 7d f4 ff          	cmp    DWORD PTR [rbp-0xc],0xffffffff
    1604:	74 06                	je     160c <read_operation+0x54>
    1606:	83 7d f4 00          	cmp    DWORD PTR [rbp-0xc],0x0
    160a:	75 11                	jne    161d <read_operation+0x65>
    160c:	48 8d 05 44 0a 00 00 	lea    rax,[rip+0xa44]        # 2057 <_IO_stdin_used+0x57>
    1613:	48 89 c7             	mov    rdi,rax
    1616:	e8 e5 fa ff ff       	call   1100 <puts@plt>
    161b:	eb 42                	jmp    165f <read_operation+0xa7>
    161d:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
    1620:	89 c7                	mov    edi,eax
    1622:	e8 62 fc ff ff       	call   1289 <is_valid_index>
    1627:	83 f0 01             	xor    eax,0x1
    162a:	84 c0                	test   al,al
    162c:	74 11                	je     163f <read_operation+0x87>
    162e:	48 8d 05 38 0a 00 00 	lea    rax,[rip+0xa38]        # 206d <_IO_stdin_used+0x6d>
    1635:	48 89 c7             	mov    rdi,rax
    1638:	e8 c3 fa ff ff       	call   1100 <puts@plt>
    163d:	eb 20                	jmp    165f <read_operation+0xa7>
    163f:	8b 45 f0             	mov    eax,DWORD PTR [rbp-0x10]
    1642:	48 98                	cdqe
    1644:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
    164b:	00 
    164c:	48 8d 05 2d 2a 00 00 	lea    rax,[rip+0x2a2d]        # 4080 <ptr_table>
    1653:	48 8b 04 02          	mov    rax,QWORD PTR [rdx+rax*1]
    1657:	48 89 c7             	mov    rdi,rax
    165a:	e8 a1 fa ff ff       	call   1100 <puts@plt>
    165f:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    1663:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    166a:	00 00 
    166c:	74 05                	je     1673 <read_operation+0xbb>
    166e:	e8 bd fa ff ff       	call   1130 <__stack_chk_fail@plt>
    1673:	c9                   	leave
    1674:	c3                   	ret

0000000000001675 <write_operation>:
    1675:	f3 0f 1e fa          	endbr64
    1679:	55                   	push   rbp
    167a:	48 89 e5             	mov    rbp,rsp
    167d:	48 83 ec 30          	sub    rsp,0x30
    1681:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
    1688:	00 00 
    168a:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
    168e:	31 c0                	xor    eax,eax
    1690:	48 8d 05 a9 09 00 00 	lea    rax,[rip+0x9a9]        # 2040 <_IO_stdin_used+0x40>
    1697:	48 89 c7             	mov    rdi,rax
    169a:	e8 61 fa ff ff       	call   1100 <puts@plt>
    169f:	48 8d 45 dc          	lea    rax,[rbp-0x24]
    16a3:	48 89 c6             	mov    rsi,rax
    16a6:	48 8d 05 a7 09 00 00 	lea    rax,[rip+0x9a7]        # 2054 <_IO_stdin_used+0x54>
    16ad:	48 89 c7             	mov    rdi,rax
    16b0:	b8 00 00 00 00       	mov    eax,0x0
    16b5:	e8 d6 fa ff ff       	call   1190 <__isoc99_scanf@plt>
    16ba:	89 45 e4             	mov    DWORD PTR [rbp-0x1c],eax
    16bd:	83 7d e4 ff          	cmp    DWORD PTR [rbp-0x1c],0xffffffff
    16c1:	74 06                	je     16c9 <write_operation+0x54>
    16c3:	83 7d e4 00          	cmp    DWORD PTR [rbp-0x1c],0x0
    16c7:	75 14                	jne    16dd <write_operation+0x68>
    16c9:	48 8d 05 07 0a 00 00 	lea    rax,[rip+0xa07]        # 20d7 <_IO_stdin_used+0xd7>
    16d0:	48 89 c7             	mov    rdi,rax
    16d3:	e8 28 fa ff ff       	call   1100 <puts@plt>
    16d8:	e9 ac 00 00 00       	jmp    1789 <write_operation+0x114>
    16dd:	8b 45 dc             	mov    eax,DWORD PTR [rbp-0x24]
    16e0:	89 c7                	mov    edi,eax
    16e2:	e8 a2 fb ff ff       	call   1289 <is_valid_index>
    16e7:	83 f0 01             	xor    eax,0x1
    16ea:	84 c0                	test   al,al
    16ec:	74 14                	je     1702 <write_operation+0x8d>
    16ee:	48 8d 05 78 09 00 00 	lea    rax,[rip+0x978]        # 206d <_IO_stdin_used+0x6d>
    16f5:	48 89 c7             	mov    rdi,rax
    16f8:	e8 03 fa ff ff       	call   1100 <puts@plt>
    16fd:	e9 87 00 00 00       	jmp    1789 <write_operation+0x114>
    1702:	e8 49 fa ff ff       	call   1150 <getchar@plt>
    1707:	48 8d 05 de 09 00 00 	lea    rax,[rip+0x9de]        # 20ec <_IO_stdin_used+0xec>
    170e:	48 89 c7             	mov    rdi,rax
    1711:	e8 ea f9 ff ff       	call   1100 <puts@plt>
    1716:	8b 45 dc             	mov    eax,DWORD PTR [rbp-0x24]
    1719:	48 98                	cdqe
    171b:	48 8d 14 85 00 00 00 	lea    rdx,[rax*4+0x0]
    1722:	00 
    1723:	48 8d 05 b6 29 00 00 	lea    rax,[rip+0x29b6]        # 40e0 <ptr_size_table>
    172a:	8b 04 02             	mov    eax,DWORD PTR [rdx+rax*1]
    172d:	89 45 e8             	mov    DWORD PTR [rbp-0x18],eax
    1730:	8b 45 dc             	mov    eax,DWORD PTR [rbp-0x24]
    1733:	48 98                	cdqe
    1735:	48 8d 14 c5 00 00 00 	lea    rdx,[rax*8+0x0]
    173c:	00 
    173d:	48 8d 05 3c 29 00 00 	lea    rax,[rip+0x293c]        # 4080 <ptr_table>
    1744:	48 8b 04 02          	mov    rax,QWORD PTR [rdx+rax*1]
    1748:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
    174c:	c7 45 e0 00 00 00 00 	mov    DWORD PTR [rbp-0x20],0x0
    1753:	eb 2c                	jmp    1781 <write_operation+0x10c>
    1755:	e8 f6 f9 ff ff       	call   1150 <getchar@plt>
    175a:	89 45 ec             	mov    DWORD PTR [rbp-0x14],eax
    175d:	83 7d ec ff          	cmp    DWORD PTR [rbp-0x14],0xffffffff
    1761:	74 26                	je     1789 <write_operation+0x114>
    1763:	83 7d ec 0a          	cmp    DWORD PTR [rbp-0x14],0xa
    1767:	74 20                	je     1789 <write_operation+0x114>
    1769:	8b 45 e0             	mov    eax,DWORD PTR [rbp-0x20]
    176c:	8d 50 01             	lea    edx,[rax+0x1]
    176f:	89 55 e0             	mov    DWORD PTR [rbp-0x20],edx
    1772:	48 63 d0             	movsxd rdx,eax
    1775:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
    1779:	48 01 d0             	add    rax,rdx
    177c:	8b 55 ec             	mov    edx,DWORD PTR [rbp-0x14]
    177f:	88 10                	mov    BYTE PTR [rax],dl
    1781:	8b 45 e0             	mov    eax,DWORD PTR [rbp-0x20]
    1784:	3b 45 e8             	cmp    eax,DWORD PTR [rbp-0x18]
    1787:	7c cc                	jl     1755 <write_operation+0xe0>
    1789:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
    178d:	64 48 2b 04 25 28 00 	sub    rax,QWORD PTR fs:0x28
    1794:	00 00 
    1796:	74 05                	je     179d <write_operation+0x128>
    1798:	e8 93 f9 ff ff       	call   1130 <__stack_chk_fail@plt>
    179d:	c9                   	leave
    179e:	c3                   	ret

000000000000179f <menu_loop>:
    179f:	f3 0f 1e fa          	endbr64
    17a3:	55                   	push   rbp
    17a4:	48 89 e5             	mov    rbp,rsp
    17a7:	48 83 ec 10          	sub    rsp,0x10
    17ab:	48 8d 05 4b 09 00 00 	lea    rax,[rip+0x94b]        # 20fd <_IO_stdin_used+0xfd>
    17b2:	48 89 c7             	mov    rdi,rax
    17b5:	e8 46 f9 ff ff       	call   1100 <puts@plt>
    17ba:	90                   	nop
    17bb:	e8 90 f9 ff ff       	call   1150 <getchar@plt>
    17c0:	89 45 fc             	mov    DWORD PTR [rbp-0x4],eax
    17c3:	83 7d fc 0a          	cmp    DWORD PTR [rbp-0x4],0xa
    17c7:	74 f2                	je     17bb <menu_loop+0x1c>
    17c9:	83 7d fc ff          	cmp    DWORD PTR [rbp-0x4],0xffffffff
    17cd:	0f 84 bd 00 00 00    	je     1890 <menu_loop+0xf1>
    17d3:	83 7d fc 35          	cmp    DWORD PTR [rbp-0x4],0x35
    17d7:	7f 3c                	jg     1815 <menu_loop+0x76>
    17d9:	83 7d fc 0a          	cmp    DWORD PTR [rbp-0x4],0xa
    17dd:	0f 8c 96 00 00 00    	jl     1879 <menu_loop+0xda>
    17e3:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
    17e6:	83 e8 0a             	sub    eax,0xa
    17e9:	83 f8 2b             	cmp    eax,0x2b
    17ec:	0f 87 87 00 00 00    	ja     1879 <menu_loop+0xda>
    17f2:	89 c0                	mov    eax,eax
    17f4:	48 8d 14 85 00 00 00 	lea    rdx,[rax*4+0x0]
    17fb:	00 
    17fc:	48 8d 05 3d 09 00 00 	lea    rax,[rip+0x93d]        # 2140 <_IO_stdin_used+0x140>
    1803:	8b 04 02             	mov    eax,DWORD PTR [rdx+rax*1]
    1806:	48 98                	cdqe
    1808:	48 8d 15 31 09 00 00 	lea    rdx,[rip+0x931]        # 2140 <_IO_stdin_used+0x140>
    180f:	48 01 d0             	add    rax,rdx
    1812:	3e ff e0             	notrack jmp rax
    1815:	83 7d fc 66          	cmp    DWORD PTR [rbp-0x4],0x66
    1819:	74 43                	je     185e <menu_loop+0xbf>
    181b:	eb 5c                	jmp    1879 <menu_loop+0xda>
    181d:	b8 00 00 00 00       	mov    eax,0x0
    1822:	e8 69 fc ff ff       	call   1490 <manage_allocation>
    1827:	eb 62                	jmp    188b <menu_loop+0xec>
    1829:	b8 00 00 00 00       	mov    eax,0x0
    182e:	e8 69 fb ff ff       	call   139c <clear_memory>
    1833:	eb 56                	jmp    188b <menu_loop+0xec>
    1835:	b8 00 00 00 00       	mov    eax,0x0
    183a:	e8 79 fd ff ff       	call   15b8 <read_operation>
    183f:	eb 4a                	jmp    188b <menu_loop+0xec>
    1841:	b8 00 00 00 00       	mov    eax,0x0
    1846:	e8 2a fe ff ff       	call   1675 <write_operation>
    184b:	eb 3e                	jmp    188b <menu_loop+0xec>
    184d:	48 8d 05 bd 08 00 00 	lea    rax,[rip+0x8bd]        # 2111 <_IO_stdin_used+0x111>
    1854:	48 89 c7             	mov    rdi,rax
    1857:	e8 a4 f8 ff ff       	call   1100 <puts@plt>
    185c:	eb 33                	jmp    1891 <menu_loop+0xf2>
    185e:	b8 00 00 00 00       	mov    eax,0x0
    1863:	e8 7f fa ff ff       	call   12e7 <read_flag>
    1868:	48 8d 05 b5 08 00 00 	lea    rax,[rip+0x8b5]        # 2124 <_IO_stdin_used+0x124>
    186f:	48 89 c7             	mov    rdi,rax
    1872:	e8 89 f8 ff ff       	call   1100 <puts@plt>
    1877:	eb 12                	jmp    188b <menu_loop+0xec>
    1879:	48 8d 05 b1 08 00 00 	lea    rax,[rip+0x8b1]        # 2131 <_IO_stdin_used+0x131>
    1880:	48 89 c7             	mov    rdi,rax
    1883:	e8 78 f8 ff ff       	call   1100 <puts@plt>
    1888:	eb 01                	jmp    188b <menu_loop+0xec>
    188a:	90                   	nop
    188b:	e9 1b ff ff ff       	jmp    17ab <menu_loop+0xc>
    1890:	90                   	nop
    1891:	c9                   	leave
    1892:	c3                   	ret

0000000000001893 <main>:
    1893:	f3 0f 1e fa          	endbr64
    1897:	55                   	push   rbp
    1898:	48 89 e5             	mov    rbp,rsp
    189b:	48 83 ec 10          	sub    rsp,0x10
    189f:	89 7d fc             	mov    DWORD PTR [rbp-0x4],edi
    18a2:	48 89 75 f0          	mov    QWORD PTR [rbp-0x10],rsi
    18a6:	48 8b 05 83 27 00 00 	mov    rax,QWORD PTR [rip+0x2783]        # 4030 <stdin@GLIBC_2.2.5>
    18ad:	b9 00 00 00 00       	mov    ecx,0x0
    18b2:	ba 02 00 00 00       	mov    edx,0x2
    18b7:	be 00 00 00 00       	mov    esi,0x0
    18bc:	48 89 c7             	mov    rdi,rax
    18bf:	e8 ac f8 ff ff       	call   1170 <setvbuf@plt>
    18c4:	48 8b 05 55 27 00 00 	mov    rax,QWORD PTR [rip+0x2755]        # 4020 <stdout@GLIBC_2.2.5>
    18cb:	b9 00 00 00 00       	mov    ecx,0x0
    18d0:	ba 02 00 00 00       	mov    edx,0x2
    18d5:	be 00 00 00 00       	mov    esi,0x0
    18da:	48 89 c7             	mov    rdi,rax
    18dd:	e8 8e f8 ff ff       	call   1170 <setvbuf@plt>
    18e2:	48 8b 05 57 27 00 00 	mov    rax,QWORD PTR [rip+0x2757]        # 4040 <stderr@GLIBC_2.2.5>
    18e9:	b9 00 00 00 00       	mov    ecx,0x0
    18ee:	ba 02 00 00 00       	mov    edx,0x2
    18f3:	be 00 00 00 00       	mov    esi,0x0
    18f8:	48 89 c7             	mov    rdi,rax
    18fb:	e8 70 f8 ff ff       	call   1170 <setvbuf@plt>
    1900:	48 8d 05 e9 08 00 00 	lea    rax,[rip+0x8e9]        # 21f0 <_IO_stdin_used+0x1f0>
    1907:	48 89 c7             	mov    rdi,rax
    190a:	e8 f1 f7 ff ff       	call   1100 <puts@plt>
    190f:	b8 00 00 00 00       	mov    eax,0x0
    1914:	e8 86 fe ff ff       	call   179f <menu_loop>
    1919:	b8 00 00 00 00       	mov    eax,0x0
    191e:	c9                   	leave
    191f:	c3                   	ret

Disassembly of section .fini:

0000000000001920 <_fini>:
    1920:	f3 0f 1e fa          	endbr64
    1924:	48 83 ec 08          	sub    rsp,0x8
    1928:	48 83 c4 08          	add    rsp,0x8
    192c:	c3                   	ret
