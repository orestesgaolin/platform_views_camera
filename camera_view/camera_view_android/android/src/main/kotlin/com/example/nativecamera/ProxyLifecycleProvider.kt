package com.example.nativecamera

import android.app.Activity
import android.app.Application
import android.os.Bundle
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry

class ProxyLifecycleProvider(activity: Activity) :
    Application.ActivityLifecycleCallbacks, LifecycleOwner {
    private val registrarActivityHashCode: Int
    private val _lifecycle = LifecycleRegistry(this)

    init {
        this.registrarActivityHashCode = activity.hashCode();
        activity.application.registerActivityLifecycleCallbacks(this);
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        if (activity.hashCode() !== registrarActivityHashCode) {
            return
        }
        _lifecycle.handleLifecycleEvent(Lifecycle.Event.ON_CREATE)
    }

    override fun onActivityStarted(activity: Activity) {
        if (activity.hashCode() !== registrarActivityHashCode) {
            return
        }
        _lifecycle.handleLifecycleEvent(Lifecycle.Event.ON_START)
    }

    override fun onActivityResumed(activity: Activity) {
        if (activity.hashCode() !== registrarActivityHashCode) {
            return
        }
        _lifecycle.handleLifecycleEvent(Lifecycle.Event.ON_RESUME)
    }

    override fun onActivityPaused(activity: Activity) {
        if (activity.hashCode() !== registrarActivityHashCode) {
            return
        }
        _lifecycle.handleLifecycleEvent(Lifecycle.Event.ON_PAUSE)
    }

    override fun onActivityStopped(activity: Activity) {
        if (activity.hashCode() !== registrarActivityHashCode) {
            return
        }
        _lifecycle.handleLifecycleEvent(Lifecycle.Event.ON_STOP)
    }

    override fun onActivitySaveInstanceState(p0: Activity, p1: Bundle) {

    }

    override fun onActivityDestroyed(activity: Activity) {
        if (activity.hashCode() !== registrarActivityHashCode) {
            return
        }
        activity.getApplication().unregisterActivityLifecycleCallbacks(this)
        _lifecycle.handleLifecycleEvent(Lifecycle.Event.ON_DESTROY)
    }

    override fun getLifecycle(): Lifecycle {
        return _lifecycle
    }
}