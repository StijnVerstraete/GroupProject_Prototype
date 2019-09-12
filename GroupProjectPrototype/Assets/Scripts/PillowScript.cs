using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Collider))]
[RequireComponent(typeof(Rigidbody))]
public class PillowScript : MonoBehaviour
{
    [SerializeField] private int _damage;
    private Rigidbody _rigidbody;
    private bool _isThrown;

    private float _pickupCooldown=1;
    private float _pickupTimer=0;

    // Start is called before the first frame update
    void Awake()
    {
        _pickupTimer = _pickupCooldown;
        _rigidbody = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        if (_pickupTimer > _pickupCooldown && transform.parent==null)
        {
            gameObject.layer = 0;
        }
        _pickupTimer += Time.deltaTime;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (_isThrown)
        {
            IDamageable damagable = collision.gameObject.GetComponent<IDamageable>();
            if (damagable != null)
            {
                damagable.TakeDamage(_damage);
            }
            _isThrown = false;
        }
    }

    public void Throw(Vector3 force)
    {
        _rigidbody.isKinematic = false;
        transform.parent = null;
        _isThrown = true;
        _rigidbody.AddForce(force, ForceMode.Impulse);
        _pickupTimer = 0;
    }

    public void Pickup(Transform parent)
    {
        if (_pickupTimer >= _pickupCooldown)
        {
            transform.parent = parent;
            gameObject.layer = parent.gameObject.layer;
            transform.localPosition = Vector3.zero;
            _rigidbody.isKinematic = true;
        }
        
    }
}
