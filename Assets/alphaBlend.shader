Shader "Custom/alphaBlend"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        // Tags ������ Transparent �� �ٲ����ν�, ���� ���̴��� '���� ���� ���̴�(������ ���̴�)'�� ��ȯ��.
        // �̰� ���� �ǹ̳ĸ�, ���� �� ���̴��� ����� ������Ʈ(�޽�)�� ������ ������Ʈ�� �� �׷��� ������ ��ٸ��ٴ� �ǹ���.
        // ��Ȯ�� ���ϸ�, "Queue"="Transparent" �� �����ϸ�, ������ ������Ʈ ������ �׸���� ������� ���� ��.
        // �� ������ ���̴��� �ٲ�����? ���� Quad �޽��� �����ϴ� �ؽ��İ� ������ ó���� �Ǿ�� �ϴ� Ǯ �ؽ��Ķ�!
        // ������ ������Ʈ ������ ó�� ���� ������ p.454 ~ 456 ����
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        cull off // �� �߷����⸦ ��Ȱ��ȭ�ؼ� Ǯ �ؽ��ĸ� ���� Quad �� ����� ��� �������� �� �ֵ��� ��.

        CGPROGRAM

        // Lambert ����Ʈ �⺻������ ����
        #pragma surface surf Lambert alpha:fade // alpha:fade ���� �߰������ ���� ���� ���̴��� �����.

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }

    // FallBack "Diffuse"
    FallBack "Legacy Shaders/Tranparent/VertexLit" // Plane(�ٴ���)�� �߰��� �� �帮��� Quad �� �׸��ڸ� �����ϱ� ���� FallBack ���̴��� ������.
}

/*
    FallBack ���̴�

    ���� FallBack �� �����ϴ� ���̴���
    ���� ���̴��� ǥ���ϴ� �Ϳ� ������ ���,
    ��ü�ؼ� ����� '����� ���̴�'�� �����ϴ� Ű����������,

    ������ ó��
    '�׸���'�� ������ ���̴��� ������ ������
    FallBack �� ������ ����� ���̴��� ����Ǵ� ����
    Ȯ���� �� ����.

    �׷��� ������ ó�� ����Ƽ ���� ���̴� �߿���
    Legacy Shaders/Transparent/... ���丮�� ����� ���̴���
    �ƹ��ų� �����ͼ� �׸��ڿ� �����ϸ�
    �׸��ڰ� ������� �� �� ����.
*/