using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DummyScript : MonoBehaviour, IDamageable
{
    [SerializeField] private int _health=100;

    public void TakeDamage(int damage)
    {
        _health -= damage;
        if (_health <= 0)
            Die();
    }

    public void TakeDamage(int damage, float stunTime)
    {
        TakeDamage(damage);
    }

    private void Die()
    {
        GameObject.Destroy(gameObject);
    }
}
