#!/bin/bash
# ============================================================
# Prof Ali The Witchdoctor - PythonAnywhere Full Setup Script
# ============================================================
# Run this in a PythonAnywhere Bash console:
#   bash setup_pythonanywhere.sh
# ============================================================

set -e

USERNAME="profalithewitchdoctor"
DOMAIN="${USERNAME}.pythonanywhere.com"
PROJECT_DIR="/home/${USERNAME}/profali"
VENV_DIR="/home/${USERNAME}/.virtualenvs/profali"
GITHUB_REPO="https://github.com/nyoroku/profali.git"
PYTHON_VERSION="python3.10"

echo "========================================="
echo "  Prof Ali - PythonAnywhere Setup"
echo "========================================="

# ------------------------------------------
# 1. Clone the repository
# ------------------------------------------
echo ""
echo "[1/8] Cloning repository..."
if [ -d "$PROJECT_DIR" ]; then
    echo "  Project directory exists. Pulling latest..."
    cd "$PROJECT_DIR"
    git pull origin master
else
    git clone "$GITHUB_REPO" "$PROJECT_DIR"
    cd "$PROJECT_DIR"
fi
echo "  ✓ Repository ready."

# ------------------------------------------
# 2. Create virtual environment
# ------------------------------------------
echo ""
echo "[2/8] Setting up virtual environment..."
if [ -d "$VENV_DIR" ]; then
    echo "  Virtualenv already exists."
else
    $PYTHON_VERSION -m venv "$VENV_DIR"
fi
source "${VENV_DIR}/bin/activate"
echo "  ✓ Virtualenv activated."

# ------------------------------------------
# 3. Install dependencies
# ------------------------------------------
echo ""
echo "[3/8] Installing Python packages..."
pip install --upgrade pip
pip install django django-crispy-forms crispy-tailwind django-imagekit django-tinymce pillow requests
echo "  ✓ All packages installed."

# ------------------------------------------
# 4. Create media directories
# ------------------------------------------
echo ""
echo "[4/8] Creating media directories..."
mkdir -p "${PROJECT_DIR}/media/services"
mkdir -p "${PROJECT_DIR}/media/testimonies"
mkdir -p "${PROJECT_DIR}/media/blogs"
echo "  ✓ Media directories created."

# ------------------------------------------
# 5. Download images for services & testimonies
# ------------------------------------------
echo ""
echo "[5/8] Downloading herbalist images..."

# Service images (using free stock photos)
curl -sL "https://images.unsplash.com/photo-1509114397022-ed747cca3f65?w=400&h=400&fit=crop" -o "${PROJECT_DIR}/media/services/spiritual_cleansing.jpg" 2>/dev/null || echo "  Using fallback for spiritual_cleansing"
curl -sL "https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=400&h=400&fit=crop" -o "${PROJECT_DIR}/media/services/love_unity.jpg" 2>/dev/null || echo "  Using fallback for love_unity"
curl -sL "https://images.unsplash.com/photo-1553729459-uj67h83f5se0?w=400&h=400&fit=crop" -o "${PROJECT_DIR}/media/services/wealth_abundance.jpg" 2>/dev/null || echo "  Using fallback for wealth"
curl -sL "https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=400&h=400&fit=crop" -o "${PROJECT_DIR}/media/services/justice.jpg" 2>/dev/null || echo "  Using fallback for justice"
curl -sL "https://images.unsplash.com/photo-1471193945509-9ad0617afabf?w=400&h=400&fit=crop" -o "${PROJECT_DIR}/media/services/herbal_healing.jpg" 2>/dev/null || echo "  Using fallback for herbal_healing"

# Testimonial placeholder images
curl -sL "https://i.pravatar.cc/256?img=32" -o "${PROJECT_DIR}/media/testimonies/sarah.jpg" 2>/dev/null || echo "  Using fallback for sarah"
curl -sL "https://i.pravatar.cc/256?img=60" -o "${PROJECT_DIR}/media/testimonies/john.jpg" 2>/dev/null || echo "  Using fallback for john"
curl -sL "https://i.pravatar.cc/256?img=25" -o "${PROJECT_DIR}/media/testimonies/amina.jpg" 2>/dev/null || echo "  Using fallback for amina"

# Blog images
curl -sL "https://images.unsplash.com/photo-1471193945509-9ad0617afabf?w=400&h=400&fit=crop" -o "${PROJECT_DIR}/media/blogs/herbs.jpg" 2>/dev/null || echo "  Using fallback for herbs"
curl -sL "https://images.unsplash.com/photo-1509114397022-ed747cca3f65?w=400&h=400&fit=crop" -o "${PROJECT_DIR}/media/blogs/cleansing.jpg" 2>/dev/null || echo "  Using fallback for cleansing"

echo "  ✓ Images downloaded."

# ------------------------------------------
# 6. Run migrations & seed database
# ------------------------------------------
echo ""
echo "[6/8] Running migrations and seeding database..."
cd "$PROJECT_DIR"
python manage.py migrate

python manage.py shell << 'SEED_EOF'
from rehab.models import Service, Testimony, Blog, Career

# Clear old data
Service.objects.all().delete()
Testimony.objects.all().delete()
Blog.objects.all().delete()
Career.objects.all().delete()

# ---- SERVICES ----
Service.objects.create(
    name="Spiritual Cleansing & Protection",
    summary="Remove dark energies, evil spirits, and negative vibrations from your life and home.",
    body="<p>Do you feel weighed down by negative energy? Our spiritual cleansing rituals use sacred herbs and ancestral wisdom to purge darkness and shield you from future harm. Prof Ali performs ancient rites passed down through generations to restore your spiritual balance and protect your family.</p>",
    image="services/spiritual_cleansing.jpg"
)
Service.objects.create(
    name="Love & Relationship Harmony",
    summary="Bring back lost lovers, fix broken marriages, and attract your soulmate today.",
    body="<p>Love is the foundation of life. Prof Ali provides divine guidance and traditional remedies to restore peace in relationships and reunite separated hearts. Whether you need to rekindle a lost flame or attract your destined partner, our ancestral love rituals have helped thousands find lasting happiness.</p>",
    image="services/love_unity.jpg"
)
Service.objects.create(
    name="Financial Prosperity & Success",
    summary="Unlock business growth, attract wealth, and enjoy financial luck in all your ventures.",
    body="<p>Are your finances stagnant? Prof Ali offers spiritual keys to unlock prosperity, attract new customers to your business, and clear the path to success. Our sacred prosperity herbs and rituals have transformed struggling entrepreneurs into thriving business leaders.</p>",
    image="services/wealth_abundance.jpg"
)
Service.objects.create(
    name="Court Cases & Legal Support",
    summary="Spiritual guidance and herbal support to ensure favorable outcomes in legal battles.",
    body="<p>Facing a difficult legal situation? Our traditional methods help clear the spiritual hurdles in your path, ensuring justice prevails in your favor. Prof Ali has helped countless clients navigate complex legal challenges with the power of ancestral guidance.</p>",
    image="services/justice.jpg"
)
Service.objects.create(
    name="Natural Herbal Healing",
    summary="Traditional cures for chronic illnesses and ailments where conventional medicine fails.",
    body="<p>Harnessing the power of pure African herbs, Prof Ali treats a wide range of long-standing physical and spiritual conditions with profound results. Our herbal preparations address the root causes of illness, not just the symptoms, using knowledge passed down through generations of African healing tradition.</p>",
    image="services/herbal_healing.jpg"
)

# ---- TESTIMONIALS ----
Testimony.objects.create(
    name="Sarah Mwangi",
    summary="Financial breakthrough",
    description="I had been struggling with my boutique for three years and was about to close. After a consultation with Prof Ali, my business took a turn I never imagined. Customers are now coming from everywhere! I am forever grateful for his guidance and spiritual intervention.",
    photo="testimonies/sarah.jpg"
)
Testimony.objects.create(
    name="John K.",
    summary="Marriage restored",
    description="My wife had left me for another man and I was devastated. Prof Ali helped me understand the spiritual blockages in our home. Within two weeks, she returned home and we are now closer than ever. Thank you Prof Ali for saving my family.",
    photo="testimonies/john.jpg"
)
Testimony.objects.create(
    name="Amina Mohammed",
    summary="Healing success",
    description="My son was suffering from a strange skin condition that no doctor could cure. One visit to Prof Ali and a course of his herbal medicine cleared it up completely in days. A true blessing! I recommend Prof Ali to everyone who has lost hope in modern medicine.",
    photo="testimonies/amina.jpg"
)

# ---- BLOGS ----
Blog.objects.create(
    title="The Secret Power of Sacred Herbs",
    summary="Discover how nature provides everything we need for spiritual and physical wellness.",
    body="<p>Traditional African herbalism is not just about plants; it's about the spirit within them. For centuries, our ancestors understood that every leaf, root, and bark carries a unique energy that can be harnessed for healing.</p><p>In this article, we explore the most powerful herbs used in traditional African medicine, including Moringa, African Wormwood, and the sacred Iboga root. Each of these plants has been used for generations to treat everything from common ailments to deep spiritual afflictions.</p><p>Prof Ali carefully selects and prepares these herbs using methods passed down through his lineage, ensuring maximum potency and spiritual alignment.</p>",
    picture="blogs/herbs.jpg"
)
Blog.objects.create(
    title="Signs You Need a Spiritual Cleansing",
    summary="Learn to identify the warning signs of negative energy blockages before they cause harm.",
    body="<p>Do you experience constant fatigue despite adequate rest? Are you plagued by recurring nightmares or a persistent feeling of being watched? These could be signs that your spirit is under attack from negative energies.</p><p>Other warning signs include: unexplained financial losses, sudden relationship problems, a string of bad luck, and feeling disconnected from your purpose. If you recognize three or more of these signs, it may be time to seek a spiritual cleansing.</p><p>Prof Ali specializes in identifying the source of spiritual attacks and performing comprehensive cleansing rituals that restore balance and protection to your life.</p>",
    picture="blogs/cleansing.jpg"
)

# ---- SUCCESS STORIES (CAREERS) ----
Career.objects.create(
    title="From Poverty to Prosperity: A Transformation Story",
    summary="See how one man's faith in traditional healing changed his family's legacy forever.",
    description="<p>Moses was a laborer struggling to feed his children. Despite working 12-hour days, he could barely make ends meet. After consulting Prof Ali, he discovered that a spiritual blockage placed by a jealous relative was preventing his financial growth.</p><p>Through a series of targeted cleansing rituals and prosperity herbs, Moses began to see changes within weeks. He was offered a promotion, his small side business started attracting customers, and within six months, he had saved enough to buy his first piece of land.</p><p>Today, Moses is a successful landowner and business leader in his community, and he credits his transformation to the wisdom of Prof Ali.</p>",
    status="open"
)
Career.objects.create(
    title="The Miracle of Reunited Hearts",
    summary="A deep dive into how spiritual alignment saved a family from the brink of divorce.",
    description="<p>Grace and Peter had been married for 15 years when things began to fall apart. Constant arguments, financial strain, and the influence of outsiders had driven them to the point of filing for divorce.</p><p>As a last resort, Grace visited Prof Ali, who identified a spiritual disturbance in their home caused by an envious neighbor. Through a combination of house cleansing, personal protection rituals, and relationship harmony herbs, peace was restored to their home.</p><p>Within three weeks of the cleansing, Peter and Grace reconciled. They have now been happily married for 18 years and regularly recommend Prof Ali to other couples in crisis.</p>",
    status="open"
)

print("✓ Database seeded with all herbalist data!")
SEED_EOF

echo "  ✓ Database ready."

# ------------------------------------------
# 7. Collect static files
# ------------------------------------------
echo ""
echo "[7/8] Collecting static files..."
python manage.py collectstatic --noinput
echo "  ✓ Static files collected."

# ------------------------------------------
# 8. Configure WSGI file
# ------------------------------------------
echo ""
echo "[8/8] Writing WSGI configuration..."
WSGI_FILE="/var/www/${DOMAIN//./_}_wsgi.py"

cat > "$WSGI_FILE" << WSGI_EOF
import os
import sys

path = '/home/${USERNAME}/profali'
if path not in sys.path:
    sys.path.append(path)

os.environ['DJANGO_SETTINGS_MODULE'] = 'azriel.settings'

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
WSGI_EOF

echo "  ✓ WSGI file written."

# ------------------------------------------
# Final Summary
# ------------------------------------------
echo ""
echo "========================================="
echo "  ✓ SETUP COMPLETE!"
echo "========================================="
echo ""
echo "  Your site: https://${DOMAIN}"
echo ""
echo "  IMPORTANT: Go to the PythonAnywhere Web tab and configure:"
echo "    1. Source code:    ${PROJECT_DIR}"
echo "    2. Virtualenv:    ${VENV_DIR}"
echo "    3. Static files:"
echo "       URL: /static/    Directory: ${PROJECT_DIR}/staticfiles"
echo "       URL: /media/     Directory: ${PROJECT_DIR}/media"
echo "    4. Click 'Reload' to apply changes."
echo ""
echo "  Admin: https://${DOMAIN}/admin/"
echo "  Contact: 0799 747 772"
echo ""
echo "========================================="
