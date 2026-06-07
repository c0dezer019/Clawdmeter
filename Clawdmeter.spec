# Cross-platform PyInstaller spec for Clawdmeter.
# Build with:  pyinstaller Clawdmeter.spec
# Output:      dist/Clawdmeter.exe (Windows) or dist/Clawdmeter (Linux/macOS),
#              single-file, no console.

# -*- mode: python ; coding: utf-8 -*-

import sys

block_cipher = None

# Windows wants .ico; Linux/macOS use the .png. The spec runs on the build
# host, so sys.platform reflects the target of a native build.
_icon = 'assets/icon.ico' if sys.platform == 'win32' else 'assets/icon.png'

a = Analysis(
    ['src/main.py'],
    pathex=['src'],
    binaries=[],
    datas=[
        ('assets/sprites', 'assets/sprites'),
        ('assets/icon.png', 'assets'),
        ('assets/icon.ico', 'assets'),
    ],
    hiddenimports=[],
    hookspath=[],
    runtime_hooks=[],
    excludes=[
        # QtNetwork is bundled (NOT excluded): single_instance.py uses
        # QLocalServer/QLocalSocket for the single-instance guard.
        'PySide6.QtQml',
        'PySide6.QtQuick',
        'PySide6.QtWebEngineCore',
        'PySide6.QtMultimedia',
        'PySide6.QtPdf',
        'PySide6.Qt3DCore',
        'PySide6.QtCharts',
        'PySide6.QtDataVisualization',
        'PySide6.QtOpenGL',
        'PySide6.QtSvg',
        'PySide6.QtPrintSupport',
        'PySide6.QtTest',
        'PySide6.QtSql',
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='Clawdmeter',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=_icon,
)
