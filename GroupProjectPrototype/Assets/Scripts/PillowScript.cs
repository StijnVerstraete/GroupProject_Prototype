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

    // Start is called before the first frame update
    void Start()
    {
        _rigidbody = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        
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
            gameObject.layer = 0;
            _isThrown = false;
        }
    }

    public void Throw(Vector3 force)
    {
        _rigidbody.isKinematic = false;
        transform.parent = null;
        _isThrown = true;
        _rigidbody.AddForce(force, ForceMode.Impulse);
    }

    public void Pickup(Transform parent)
    {
        transform.parent = parent;
        gameObject.layer = parent.gameObject.layer;
        transform.localPosition = Vector3.zero;
        _rigidbody.isKinematic = true;
    }
}
