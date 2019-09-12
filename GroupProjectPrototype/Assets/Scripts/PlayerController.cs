using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(PlayerMotor))]
[RequireComponent(typeof(CameraController))]
public class PlayerController : MonoBehaviour
{
    private PlayerMotor _playerMotor;
    private CameraController _cameraController;
    [SerializeField] private Transform _cameraTransform;
    [SerializeField] private Vector3 _throwForce;
    [SerializeField] private Transform _leftPillowSlot;
    [SerializeField] private Transform _rightPillowSlot;
    [SerializeField] private int _health;
    [SerializeField] private int _attackDamage;
    [SerializeField] private float _attackRange;
    [SerializeField] private float _attackCooldown;
    private float _attackCooldownTimer;
    private PillowScript _leftPillow;
    private PillowScript _rightPillow;

    private const string _leftPillowTag = "LeftPillow";
    private const string _rightPillowTag = "RightPillow";

    public static PlayerController Player { get; private set; }

    private void Awake()
    {
        Player = this;
    }
    void Start()
    {
        _playerMotor = GetComponent<PlayerMotor>();
        _cameraController = GetComponent<CameraController>();
        SetPillows();
    }

    private void SetPillows()
    {
        if (_leftPillowSlot.childCount > 0)
            _leftPillow = _leftPillowSlot.GetChild(0).GetComponent<PillowScript>();

        if (_rightPillowSlot.childCount > 0)
            _rightPillow = _rightPillowSlot.GetChild(0).GetComponent<PillowScript>();

        if (_leftPillow)
            _leftPillow.Pickup(_leftPillowSlot);
        if (_rightPillow)
            _rightPillow.Pickup(_rightPillowSlot);
    }


    // Update is called once per frame
    void Update()
    {
        _playerMotor.MoveRelativeToTransform(new Vector3(InputController.RunXAxis, 0, InputController.RunYAxis));

        _playerMotor.HorizontalAim = InputController.LookXAxis;
        _cameraController.RotateVertically(InputController.LookYAxis * _playerMotor.VerticalRotationSpeed * Time.deltaTime);

        if (InputController.AButtonDown)
        {
            _playerMotor.Jump();
            return;
        }

        if(InputController.LeftTriggerAxis > 0.2f)
        {
            ThrowPillow(_leftPillow);
            _leftPillow = null;
        }

        if (InputController.RightTriggerAxis > 0.2f)
        {
            ThrowPillow(_rightPillow);
            _rightPillow = null;
        }

        bool isAiming = InputController.LeftBumper || InputController.RightBumper;
        _cameraController.IsAiming = isAiming;
        _playerMotor.IsAiming = isAiming;

        if (InputController.XButtonDown)
        {
            TryAttack();
        }

        _attackCooldownTimer += Time.deltaTime;
    }

    private void TryAttack()
    {
        if (_attackCooldownTimer > _attackCooldown)
        {
            foreach (EnemyBehaviour enemy in EnemyBehaviour.Enemies)
            {
                if ((enemy.transform.position - transform.position).sqrMagnitude <= _attackRange * _attackRange)
                {
                    enemy.TakeDamage(_attackDamage);
                }
            }
            _attackCooldownTimer = 0;
        }
        
    }

    public void TakeDamage(int damage)
    {
        Debug.Log("yeet");
        _health -= damage;
        if (_health <= 0)
            Debug.Log("yo he dead");
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag(_leftPillowTag))
        {
            other.GetComponent<PillowScript>().Pickup(_leftPillowSlot);
            _leftPillow = other.GetComponent<PillowScript>();
        }
        if (other.CompareTag(_rightPillowTag))
        {
            other.GetComponent<PillowScript>().Pickup(_rightPillowSlot);
            _rightPillow = other.GetComponent<PillowScript>();
        }
    }

    private void ThrowPillow(PillowScript pillow)
    {
        if(pillow)
            pillow.Throw(_cameraTransform.TransformVector(_throwForce));
    }
}
