using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PillowPhysicsController : MonoBehaviour
{
    [SerializeField] private Transform _bone1, _bone2;

    // Update is called once per frame
    void Update()
    {
        ConstrainBone(_bone1);
        ConstrainBone(_bone2);
    }
    private void ConstrainBone(Transform bone)
    {
        if (bone.rotation.z > 70 || bone.rotation.z < -70)
        {
            bone.Rotate(new Vector3(0, 0, Mathf.Sign(bone.rotation.z)));
        }
    }
}
