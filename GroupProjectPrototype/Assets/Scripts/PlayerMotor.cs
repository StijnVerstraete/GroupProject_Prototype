using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(CharacterController))]
public class PlayerMotor : MonoBehaviour {

    [Header("Locomotion Parameters")]

    [SerializeField] public float MaxRunningSpeed = (30.0f * 1000) / (60 * 60);

    [SerializeField] private float _acceleration = 3; // [m/s^2]

    [SerializeField] private float _jumpHeight = 1; // [m/s^2]

    [SerializeField] private float _dragOnGround = 1;

    [SerializeField] private float _dragInAir = 1;

    [SerializeField] private bool _canMoveInAir;

    [SerializeField] private float _walkingSpeedMultiplier=.5f;
    [SerializeField] private float _walkingAimMultiplier=.5f;

    private CharacterController _characterController;
    private Transform _playerTransform;

    private Vector3 _movement;
    private float _horizontalAim;

    private bool _jump;
    public bool IsAiming { get; set; }
    public bool IsGrounded { get => _isGroundedChecker.IsGrounded; }
    public bool HasGravity { get; set; } = true;
    public Vector3 Movement
    {
        get
        {
            if (IsAiming)
                return _movement * _walkingSpeedMultiplier;
            return _movement;
        }
    }
    public float HorizontalAim
    {
        get
        {
            if (IsAiming)
                return _horizontalAim * _walkingAimMultiplier;
            return _horizontalAim;
        }
        set { _horizontalAim = value; }
    }

    private Vector3 _velocity = Vector3.zero;
    public Vector3 Velocity { get => _velocity; }

    [SerializeField] private float _horizontalRotationSpeed;
    public float HorizontalRotationSpeed{ get => _horizontalRotationSpeed; }

    [SerializeField] private float _verticalRotationSpeed;
    public float VerticalRotationSpeed{ get => _verticalRotationSpeed; }

    [SerializeField] private LayerMask _mapLayerMask;
    [SerializeField] private IsGroundedCheckerScript _isGroundedChecker;
    public IsGroundedCheckerScript IsGroundedChecker { get=> _isGroundedChecker;}

    // Use this for initialization
    void Start() {
        _characterController = GetComponent<CharacterController>();
        _playerTransform = transform;
    }

    // Update is called once per frame
    void FixedUpdate() {
        ApplyGround();
        ApplyGravity();

        ApplyRotation();
        ApplyMovement();
        ApplyGroundDrag();

        ApplyAirDrag();
        ApplyJump();

        LimitMaximumRunningSpeed();

        _characterController.Move(_velocity * Time.deltaTime);
    }

    public void Move(Vector3 direction)
    {
        _movement = direction.normalized;
    }

    public void MoveRelativeToTransform(Vector3 relativeDirection)
    {
        _movement = RelativeDirection(relativeDirection).normalized;
    }

    private void ApplyMovement()
    {
        if (IsGrounded || _canMoveInAir)
        {
                _velocity += _movement * _acceleration * Time.deltaTime; // F(= m.a) [m/s^2] * t [s]
        }
    }

    private Vector3 RelativeDirection(Vector3 direction)
    {
        Quaternion forwardRotation =
            Quaternion.LookRotation(Vector3.Scale(_playerTransform.forward, new Vector3(1, 0, 1)));

        Vector3 relativeMovement = forwardRotation * direction;
        return relativeMovement;
    }

    private void ApplyGround()
    {
        if (IsGrounded)
        {
            _velocity -= Vector3.Project(_velocity, Physics.gravity.normalized);
        }
    }

    private void ApplyGravity()
    {
        if (HasGravity && !IsGrounded)
        {
            _velocity += Physics.gravity * Time.deltaTime; // g[m/s^2] * t[s]
        }

    }

    private void ApplyJump()
    {
        if (_jump && IsGrounded)
        {
            _velocity += -Physics.gravity.normalized * Mathf.Sqrt(2 * Physics.gravity.magnitude * _jumpHeight);
            _jump = false;
        }

    }

    private void ApplyAirDrag()
    {
        if (!IsGrounded)
        {
            Vector3 xzVelocity = Vector3.Scale(_velocity, new Vector3(1, 0, 1));
            xzVelocity = xzVelocity * (1 - Time.deltaTime * _dragInAir);

            xzVelocity.y = _velocity.y;
            _velocity = xzVelocity;
        }
    }

    private void ApplyGroundDrag()
    {
        if (IsGrounded)
        {
            _velocity = _velocity * (1 - Time.deltaTime * _dragOnGround);
        }
    }

    private void LimitMaximumRunningSpeed()
    {
        Vector3 yVelocity = Vector3.Scale(_velocity, new Vector3(0, 1, 0));

        Vector3 xzVelocity = Vector3.Scale(_velocity, new Vector3(1, 0, 1));
        Vector3 clampedXzVelocity = Vector3.ClampMagnitude(xzVelocity, MaxRunningSpeed);

        _velocity = yVelocity + clampedXzVelocity;
    }

    private void ApplyRotation()
    {
        _characterController.transform.eulerAngles += new Vector3(0, HorizontalAim, 0) * _horizontalRotationSpeed * Time.deltaTime;
    }

    public void StopMoving()
    {
        _movement = Vector3.zero;
        _velocity = Vector3.zero;
        HorizontalAim = 0;
    }

    public float GetDistanceFromGround()
    {
        RaycastHit hit;
        if (Physics.Raycast(_playerTransform.position, Vector3.down, out hit, 1000, _mapLayerMask))
        {
            return (hit.point - _playerTransform.position).magnitude;
        }

        return 1000;
    }

    public void SetPosition(Vector3 position)
    {
        _playerTransform.position = position;
    }

    public void Jump()
    {
        if (IsGrounded)
        {
            _jump = true;
        }
    }
}
