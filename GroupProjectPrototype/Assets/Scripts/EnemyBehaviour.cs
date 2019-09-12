using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

[RequireComponent(typeof(NavMeshAgent))]
[RequireComponent(typeof(PlayerMotor))]
public class EnemyBehaviour : MonoBehaviour, IDamageable
{
    private NavMeshAgent _navMeshAgent;
    private PlayerMotor _playerMotor;

    private static List<EnemyBehaviour> _enemies = new List<EnemyBehaviour>();
    public static List<EnemyBehaviour> Enemies => _enemies;

    [SerializeField] private float _fov;
    [SerializeField] private Vector3 _eyesPosition;
    [SerializeField] private int _health;
    [SerializeField] private int _attackDamage;
    [SerializeField] private float _attackRange;
    [SerializeField] private float _attackCooldown;
    private float _attackCooldownTimer;
    private Transform _playerTransform;

    [Space]
    [SerializeField] private Vector2 _roamingTimeRange;
    private float _roamingTime=0;
    private float _roamingTimer = 0;

    // Start is called before the first frame update
    void Start()
    {
        _enemies.Add(this);
        _navMeshAgent = GetComponent<NavMeshAgent>();
        _playerMotor = GetComponent<PlayerMotor>();
        _playerTransform = PlayerController.Player.transform;

        _navMeshAgent.updatePosition = false;
        _navMeshAgent.updateRotation = false;
        _roamingTime = Random.Range(_roamingTimeRange.x, _roamingTimeRange.y);
    }

    // Update is called once per frame
    void Update()
    {
        if (CanSeePlayer())
        {
            _navMeshAgent.SetDestination(_playerTransform.position);
            if ((transform.position- _playerTransform.position).sqrMagnitude <= _attackRange * _attackRange)
            {
                TryAttack();
            }
        }
        else
        {
            if (_roamingTimer >= _roamingTime)
            {
                SetRandomDestination();
            }
        }

        if (HasNavMeshReachedDestination())
        {
            _playerMotor.StopMoving();
        }
        else
        {
            _playerMotor.Move(_navMeshAgent.nextPosition - transform.position);
            Vector3 relativeDestination = transform.InverseTransformPoint(_navMeshAgent.destination);
            _playerMotor.HorizontalAim = relativeDestination.x / Mathf.Abs(relativeDestination.x);
        }

        _roamingTimer += Time.deltaTime;
        _attackCooldownTimer += Time.deltaTime;
    }

    private void SetRandomDestination()
    {
        _roamingTime = Random.Range(_roamingTimeRange.x, _roamingTimeRange.y);
        _roamingTimer = 0;

        _navMeshAgent.SetDestination(RandomNavSphere(transform.position, 3, -1));
    }

    public Vector3 RandomNavSphere(Vector3 origin, float range, int layermask)
    {
        Vector3 randomPosition = Random.insideUnitSphere * range;

        randomPosition += origin;

        NavMeshHit navHit;
        NavMesh.SamplePosition(randomPosition, out navHit, range, layermask);

        return navHit.position;
    }

    public bool HasNavMeshReachedDestination()
    {
        if (!_navMeshAgent.pathPending)
        {
            if (_navMeshAgent.remainingDistance <= _navMeshAgent.stoppingDistance)
            {
                if (!_navMeshAgent.hasPath || _navMeshAgent.velocity.sqrMagnitude <= 0f)
                {
                    return true;
                }
            }
        }
        return false;
    }

    public void TakeDamage(int damage)
    {
        _health -= damage;
        if (_health <= 0)
        {
            _enemies.Remove(this);
            GameObject.Destroy(gameObject);
        }
    }

    private void TryAttack()
    {
        if (_attackCooldownTimer > _attackCooldown)
        {
            PlayerController.Player.TakeDamage(_attackDamage);
            _attackCooldownTimer = 0;
        }
    }

    private bool CanSeePlayer()
    {
        Vector3 directionPlayer = _playerTransform.position - transform.position;
        if (Quaternion.Angle(transform.rotation, Quaternion.LookRotation(directionPlayer)) < _fov / 2)
        {
            RaycastHit hit;
            if (Physics.Raycast(transform.position + _eyesPosition, directionPlayer, out hit, 100))
            {
                if (hit.transform.gameObject.layer == 8)
                {
                    return true;
                }
            }
        }
        return false;
    }
}
