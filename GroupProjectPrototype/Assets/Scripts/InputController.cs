using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class InputController
{
    private const string _runXAxis = "RunX";
    private const string _runYAxis = "RunY";
    private const string _lookXAxis = "LookX";
    private const string _lookYAxis = "LookY";
    private const string _leftTriggerAxis = "LeftTrigger";
    private const string _rightTriggerAxis = "RightTrigger";

    private const string _aButton = "AButton";
    private const string _bButton = "BButton";
    private const string _yButton = "YButton";
    private const string _xButton = "XButton";
    private const string _leftBumper = "LeftBumper";
    private const string _rightBumper = "RightBumper";

    public static float RunXAxis{get=> Input.GetAxis(_runXAxis); }
    public static float RunYAxis { get=> Input.GetAxis(_runYAxis); }

    public static float LookXAxis { get => Input.GetAxis(_lookXAxis); }
    public static float LookYAxis { get => Input.GetAxis(_lookYAxis); }

    public static float LeftTriggerAxis { get => Input.GetAxis(_leftTriggerAxis); }
    public static float RightTriggerAxis { get => Input.GetAxis(_rightTriggerAxis); }

    public static bool AButtonDown { get => Input.GetButtonDown(_aButton); }
    public static bool BButtonDown { get => Input.GetButtonDown(_bButton); }
    public static bool BButton { get => Input.GetButton(_bButton); }

    public static bool YButtonDown { get => Input.GetButtonDown(_yButton); }
    public static bool XButtonDown { get => Input.GetButtonDown(_xButton); }

    public static bool LeftBumper { get => Input.GetButton(_leftBumper); }
    public static bool RightBumper{ get => Input.GetButton(_rightBumper); }
}
