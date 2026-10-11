```text
  ____   _____  __   ____  ____   ___     _ _____ ____ _____ 
 |  _ \ / _ \ \/ /  |  _ \|  _ \ / _ \   | | ____/ ___|_   _|
 | |_) | | | \  /   | |_) | |_) | | | | _| |  _|| |     | |  
 |  __/| |_| /  \   |  __/|  _ <| |_| || |_| |__| |___  | |  
 |_|    \___/_/\_\  |_|   |_| \_\\___/ \___/|_____\____| |_|  
 =========================================================
   POX LOGS DUMPER v2.0  •  Custom Recovery Log Collector
   Maintainer: txorav
 =========================================================
```

# POX PROJECT - poxlogsdumper (v2.0 Ultimate Edition)

[![Build and Package](https://github.com/POX-project/poxlogsdumper/actions/workflows/build.yml/badge.svg)](https://github.com/POX-project/poxlogsdumper/actions/workflows/build.yml)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Latest Release](https://img.shields.io/github/v/release/POX-project/poxlogsdumper?color=brightgreen)](https://github.com/POX-project/poxlogsdumper/releases)

**Maintainer:** **`txorav`**

A high-performance, flashable ZIP designed for custom recoveries (TWRP, OrangeFox, PBRP, SHRP, LineageOS Recovery) that exhaustively dumps **every diagnostic log available on Android** into a single timestamped archive: **`logsYYMMDD.zip`**.

> **100% Safe:** This tool does **NOT** flash, format, or modify any partitions. It operates strictly as a read-only diagnostics extraction tool.

---

## What Logs Are Collected?

### 1. PStore, Console-Ramoops & Hardware Crash Partitions
- **`/sys/fs/pstore/*`:** Automatically mounts `pstore` (`mount -t pstore pstore /sys/fs/pstore`) to retrieve all ramoops crash traces:
  - `console-ramoops` / `console-ramoops-0`
  - `dmesg-ramoops-*`
  - `pmsg-ramoops-*`
  - `ftrace-ramoops-*`
- **Legacy & Parameters:** `/proc/last_kmsg`, `/proc/ramoops`, `/sys/module/ramoops/parameters/*`.
- **`/dev/pmsg0`:** Dumps persistent logcat buffer snapshots from RAM.
- **Raw Partition Crash Dumps:** Detects and extracts the first 4MB header plus ASCII/UTF-8 strings from hardware crash partitions:
  - `ramoops`, `expdb` (MediaTek Exception Database), `logdump`, `rawdump`, `minidump`, `apdp`.

### 2. Complete Kernel & Execution Traces
- **Kernel Ring Buffers:**
  - `dmesg -s 4194304` (Full 4MB kernel ring buffer).
  - `dmesg -T` (Human-readable timestamps).
  - `dmesg -k` (Kernel-space only) & `dmesg -u` (Userspace only).
- **Kernel Proc Metrics:** `/proc/cmdline`, `/proc/version`, `/proc/bootconfig`, `/proc/sched_debug`, `/proc/timer_list`, `/proc/interrupts`, `/proc/softirqs`, `/proc/vmstat`, `/proc/zoneinfo`, `/proc/slabinfo`, `/proc/vmallocinfo`, `/proc/pagetypeinfo`, `/proc/buddyinfo`, `/proc/modules`, `/proc/diskstats`, `/proc/loadavg`.
- **DebugFS Traces:** Automatically mounts `debugfs` (`mount -t debugfs none /sys/kernel/debug`):
  - Ftrace ring buffer snapshot (`/sys/kernel/debug/tracing/trace`).
  - Binder transaction states, stats, and failed transaction logs.
  - Wakeup sources (battery drain / suspend blocker debugging).
  - Clock tree (`clk_summary`) and voltage regulator tree.

### 3. Recovery Session Logs
- **Current Session:** `/tmp/recovery.log*`, `/tmp/install.log`, `/tmp/twrp.log*`, `/tmp/stage`, `/tmp/last_log*`, `/tmp/minizip.log`, `/tmp/openrecoveryscript`.
- **OrangeFox & PBRP:** `/tmp/fox*.log`, `/cache/fox*.log`, `/sdcard/Fox/logs/*`, `/cache/Fox/*`, `/tmp/pbrp*.log`, `/tmp/shrp*.log`.
- **Persistent Recovery Data:** `/cache/recovery/*` (`last_log`, `last_install`, `last_kmsg`), `/data/cache/recovery/*`, `/data/system/recovery/*`.

### 4. Android System Crashes & DropBox
- **DropBox (`/data/system/dropbox/*`):** Full copy of all crash dumps, kernel panics (`SYSTEM_LAST_KMSG`, `kernel_panic`, `system_server_crash`, `system_server_wtf`, `watchdog`).
- **ANR Traces (`/data/anr/*`):** App unresponsive traces and CPU usage history.
- **Tombstones (`/data/tombstones/*`):** Native stack traces, register states, and backtraces.
- **MediaTek AEE:** `/data/aee_exp/*`, `/data/vendor/aee_exp/*`, `/data/vendor/vcore_exp/*`, `/proc/aee/*`.
- **Qualcomm Subsystem Dumps:** `/data/vendor/ramdump/*`, `/data/vendor/ssrdump/*`.
- **OEM Logs:** Xiaomi (`/data/miuilog`, `/data/mqsas`), Samsung (`/data/log`), OnePlus/ColorOS (`oppo/log`, `oplus/log`).

### 5. Live Logcat Buffers
- Captures all buffers: `main`, `system`, `crash`, `events`, `radio`, `kernel`.

### 6. Root & Su Managers
- **Magisk:** `magisk.log`, `magisk.log.bak`, `magisk_boot.log`, installed modules list & `module.prop` dumps.
- **KernelSU:** KSU logs, installed modules list, and KSU dmesg filter.
- **APatch:** APatch logs, modules list, and APatch dmesg filter.

### 7. Exhaustive Partition Tables, Raw GPT & Dynamic Partitions
- **Raw GPT Binary Headers:** Dumps primary GPT header (first 34 sectors = 17KB) and secondary backup GPT (last 33 sectors) for every disk (`mmcblk0`, `sda`, `sdb`, etc.).
- **Partition Table Tools:**
  - `sgdisk -p <disk>`: Full printout with GUIDs, partition names, sectors.
  - `sgdisk --backup`: Direct binary backup restorable via `sgdisk --load-backup`.
  - `fdisk -l` and `parted print` (if installed).
  - `blkid`: All UUIDs, PARTUUIDs, and filesystem labels.
  - `lsblk`: Detailed tree layout with mountpoints and partition labels.
- **Android Dynamic Partitions (Super Partition):**
  - `lpdump`: Full metadata dump of super dynamic partitions (`system`, `vendor`, `product`, etc.).
  - `dmsetup`: Dumps `table`, `status`, `info -c`, and tree mapping for all dm-linear partitions.
- **SysFS Partition Enumeration:** Generates a human-readable table parsed from `/sys/class/block/*` showing partition number, device node, label, start sector, sector count, size in MB, and read-only flags.
- **Symlink Maps:** Complete mapping of `/dev/block/by-name/`, `bootdevice/by-name/`, and `mapper/`.

### 8. Hardware, Properties, Thermal & Power (Sanitized for Privacy)
- **Sanitized `getprop` & `build.prop`:** Captures all device model, SoC, release, vendor configs, and Android properties while **strictly excluding private identifiers**:
  - **Zero IMEI / MEID** (`ro.ril.oem.imei*`, `ril.imei*`, `persist.radio.imei*` excluded)
  - **Zero Serial Numbers** (`ro.serialno`, `ro.boot.serialno`, `/proc/cpuinfo` Serial sanitized)
  - **Zero MAC Addresses** (Wi-Fi & Bluetooth MAC addresses redacted to `[REDACTED_MAC]`)
  - **Zero SIM Card IDs** (ICCID, IMSI, MSISDN, Phone numbers excluded)
  - **Zero CPU IDs & Tokens** (`ro.boot.cpuid`, tokens, passwords excluded)
- Active A/B boot slot (`_a` or `_b`).
- SELinux status & AVC denial filter.
- Thermal zones (temperature and cooling states).
- Battery / power supply uevent attributes.
- Device tree model and compatible strings.

---

## Target Storage Resolution

The dumper automatically checks writable storage in priority order:
1. `/sdcard` (Internal Storage)
2. `/data/media/0`
3. `/data`
4. `/cache`
5. `/tmp` (RAM disk fallback if storage is encrypted)

---

## Packaging & Building Locally

Build the flashable zip package locally by running:

```bash
./build.sh
```

This packages the flashable `poxlogsdumper.zip` inside `out/` and generates cryptographic SHA256 checksums.

The archive is named **`logsYYMMDD.zip`** (e.g. `logs261003.zip`) when flashed on device. If an existing archive with that name is present, a timestamp is appended (`logsYYMMDD_HHMMSS.zip`) so previous dumps are preserved.

The package bundles high-speed statically compiled `poxzip` binaries for both ARM64 and ARM32, with fallbacks to system `zip`, `busybox zip`, `toybox zip`, or `tar.gz`.

---

## Flashing Instructions

### In Recovery (TWRP / OrangeFox / PBRP)
1. Copy `poxlogsdumper.zip` to your device (Internal storage, MicroSD, or USB-OTG).
2. Boot into custom recovery.
3. Tap **Install**, choose `poxlogsdumper.zip`, and swipe to flash.
4. Review the log path on the screen (e.g. `/sdcard/logs261003.zip`).
5. Reboot to system or copy the file over MTP / ADB.

### In Recovery ADB Sideload
```bash
adb sideload poxlogsdumper.zip
```

---

## 🇵🇸 Solidarity
**FREE PALESTINE** — Support justice, end oppression, and spread awareness on all matters of shared humanity.
