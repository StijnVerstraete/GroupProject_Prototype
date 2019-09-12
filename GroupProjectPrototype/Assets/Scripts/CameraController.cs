using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour {

    [SerializeField] private Camera _playerCamera;
    [SerializeField] private Transform _cameraTransform;
    [SerializeField] private Transform _cameraStartRootTransform;
    [SerializeField] private Transform _cameraAimPosition;

    [Space]
    [Header("Camera Clamping Parameters")]
    [SerializeField] private float _camRotation;
    [SerializeField] private float _minCamAngle;
    [SerializeField] private float _maxCamAngle;

    public Camera PlayerCamera { get => _playerCamera; }
    public Transform CameraRoot { get => _cameraStartRootTransform; }
    public Vector3 CameraPosition { get => _cameraTransform.position; }
    public Quaternion CameraRotation { get => _cameraTransform.rotation; }

    public bool IsAiming { private get; set; }
    private Vector3 _startPosition;
    private Quaternion _startRotation;

    // Use this for initialization
    void Start () {
        _startPosition = _cameraTransform.localPosition;
        _startRotation = _cameraTransform.localRotation;
	}
	
	// Update is called once per frame
	void Update () {
        if (IsAiming)
        {
            Vector3 position = Vector3.Lerp(_cameraTransform.position, _cameraAimPosition.position, .2f);
            Quaternion rotation = Quaternion.Lerp(_cameraTransform.rotation, _cameraAimPosition.rotation, .2f);

            _cameraTransform.SetPositionAndRotation(position, rotation);
        }
        else
        {
            Vector3 position = Vector3.Lerp(_cameraTransform.localPosition, _startPosition, .2f);
            Quaternion rotation = Quaternion.Lerp(_cameraTransform.localRotation, _startRotation, .2f);

            _cameraTransform.localPosition = position;
            _cameraTransform.localRotation = rotation;
        }
    }

    public void RotateVertically(float angle)
    {
        _camRotation += angle;

        _camRotation = Mathf.Clamp(_camRotation, _minCamAngle, _maxCamAngle);

        _cameraStartRootTransform.eulerAngles = new Vector3(_camRotation, _cameraStartRootTransform.eulerAngles.y, _cameraStartRootTransform.eulerAngles.z);
    }
}
