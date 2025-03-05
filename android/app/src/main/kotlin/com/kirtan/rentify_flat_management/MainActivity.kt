package com.kirtan.rentify_flat_management

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity(), ActivityAware {
    private val EVENT_CHANNEL = "proximity_sensor_events"
    private var sensorManager: SensorManager? = null
    private var proximitySensor: Sensor? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
                    proximitySensor = sensorManager?.getDefaultSensor(Sensor.TYPE_PROXIMITY)
                    if (proximitySensor == null) {
                        eventSink?.error("SENSOR_ERROR", "Proximity sensor not available", null)
                        return
                    }
                    sensorManager?.registerListener(
                        sensorEventListener,
                        proximitySensor,
                        SensorManager.SENSOR_DELAY_NORMAL
                    )
                }

                override fun onCancel(arguments: Any?) {
                    sensorManager?.unregisterListener(sensorEventListener)
                    eventSink = null
                }

                private val sensorEventListener = object : SensorEventListener {
                    override fun onSensorChanged(event: SensorEvent?) {
                        if (event?.sensor?.type == Sensor.TYPE_PROXIMITY) {
                            val isNear = event.values[0] < event.sensor.maximumRange
                            eventSink?.success(if (isNear) 1 else 0)
                        }
                    }

                    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
                }
            }
        )
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        // Required for ActivityAware interface
    }

    override fun onDetachedFromActivity() {
        // Required for ActivityAware interface
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        // Required for ActivityAware interface
    }

    override fun onDetachedFromActivityForConfigChanges() {
        // Required for ActivityAware interface
    }
}