#!/bin/bash

# OpenClaw Thermal Monitor Diagnostics (V2)
# Diagnose and fix thermal monitoring daemon issues

echo "═══════════════════════════════════════════════════════"
echo "🌡️  Thermal Monitor Diagnostics"
echo "═══════════════════════════════════════════════════════"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Check if running on Raspberry Pi
if ! command -v vcgencmd &>/dev/null; then
    echo "⚠️  Not a Raspberry Pi or vcgencmd not available"
    echo "    Thermal monitoring only relevant for Raspberry Pi"
    echo ""
    echo "💡 For other systems, consider:"
    echo "   - lm-sensors for Linux"
    echo "   - powermetrics for macOS"
    exit 0
fi

# 1. Check if daemon is running
echo "🔍 Step 1: Checking Daemon Status"
echo "─────────────────────────────────────────────────────"
if pgrep -f "cpu_thermal_monitor.py" > /dev/null; then
    echo "✅ Daemon is running"
    PID=$(pgrep -f "cpu_thermal_monitor.py")
    echo "   PID: $PID"
else
    echo "❌ Daemon is NOT running"
    echo "   The thermal monitor needs to be started"
fi
echo ""

# 2. Check log file
echo "🔍 Step 2: Checking Log File"
echo "─────────────────────────────────────────────────────"
LOG_FILE="/tmp/pi_thermal_monitor.log"
if [ -f "$LOG_FILE" ]; then
    echo "✅ Log file exists: $LOG_FILE"
    LOG_SIZE=$(ls -lh "$LOG_FILE" | awk '{print $5}')
    echo "   Size: $LOG_SIZE"
    
    # Check for recent entries
    LAST_ENTRY=$(tail -5 "$LOG_FILE" 2>/dev/null | grep "CPU Temp" | tail -1)
    if [ -n "$LAST_ENTRY" ]; then
        echo "   Last entry: $LAST_ENTRY"
    else
        echo "   ⚠️  No recent temperature entries"
    fi
    
    # Check for errors
    ERRORS=$(grep -i "error\|exception\|failed" "$LOG_FILE" 2>/dev/null | tail -3)
    if [ -n "$ERRORS" ]; then
        echo ""
        echo "   ⚠️  Recent errors found:"
        echo "$ERRORS" | while read line; do
            echo "      $line"
        done
    fi
else
    echo "❌ Log file not found: $LOG_FILE"
    echo "   Daemon may not have started logging yet"
fi
echo ""

# 3. Check Discord configuration
echo "🔍 Step 3: Checking Discord Configuration"
echo "─────────────────────────────────────────────────────"
DAEMON_SCRIPT="$WORKSPACE/scripts/cpu_thermal_monitor.py"
if [ -f "$DAEMON_SCRIPT" ]; then
    echo "✅ Daemon script found: $DAEMON_SCRIPT"
    
    # Check for Discord token
    TOKEN=$(grep -o 'DISCORD_BOT_TOKEN=.*' "$DAEMON_SCRIPT" 2>/dev/null | head -1)
    if [ -n "$TOKEN" ]; then
        echo "   Discord token: ✅ Configured"
    else
        echo "   ⚠️  Discord token: NOT FOUND"
        echo "      The daemon needs a valid Discord bot token"
    fi
    
    # Check for channel ID
    CHANNEL=$(grep -o 'DISCORD_CHANNEL_ID=.*' "$DAEMON_SCRIPT" 2>/dev/null | head -1)
    if [ -n "$CHANNEL" ]; then
        echo "   Channel ID: ✅ Configured"
    else
        echo "   ⚠️  Channel ID: NOT FOUND"
        echo "      The daemon needs a valid Discord channel ID"
    fi
else
    echo "⚠️  Daemon script not found at expected location"
    echo "   Looking for: $DAEMON_SCRIPT"
fi
echo ""

# 4. Current temperature
echo "🔍 Step 4: Current Temperature"
echo "─────────────────────────────────────────────────────"
CURRENT_TEMP=$(vcgencmd measure_temp 2>/dev/null | cut -d'=' -f2 | cut -d"'" -f1)
if [ -n "$CURRENT_TEMP" ]; then
    echo "   Current CPU Temp: $CURRENT_TEMP"
    
    # Check thresholds
    TEMP_NUM=$(echo "$CURRENT_TEMP" | cut -d'C' -f1)
    if (( $(echo "$TEMP_NUM > 80" | bc -l) )); then
        echo "   ⚠️  WARNING: Temperature is HIGH (>80°C)"
        echo "      Consider improving cooling"
    elif (( $(echo "$TEMP_NUM > 70" | bc -l) )); then
        echo "   ⚠️  CAUTION: Temperature is elevated (>70°C)"
    else
        echo "   ✅ Temperature is normal"
    fi
else
    echo "   ❌ Could not read temperature"
fi
echo ""

# 5. Fix commands
echo "🔧 Step 5: Fix Commands"
echo "─────────────────────────────────────────────────────"
echo "If the daemon is not working, try these steps:"
echo ""
echo "1. Update Discord token:"
echo "   export DISCORD_BOT_TOKEN='your-bot-token-here'"
echo ""
echo "2. Update Discord channel ID:"
echo "   export DISCORD_CHANNEL_ID='your-channel-id-here'"
echo ""
echo "3. Start the daemon:"
echo "   nohup python3 scripts/cpu_thermal_monitor.py &"
echo ""
echo "4. Check logs in real-time:"
echo "   tail -f /tmp/pi_thermal_monitor.log"
echo ""
echo "5. Stop the daemon:"
echo "   pkill -f cpu_thermal_monitor.py"
echo ""

echo "═══════════════════════════════════════════════════════"
echo "✨ Diagnostics Complete"
echo "═══════════════════════════════════════════════════════"
