#!/bin/bash
# ============================================================
# Prof Ali The Witchdoctor - PythonAnywhere Full Setup Script
# ============================================================

USERNAME="profalithewitchdoctor"
DOMAIN="${USERNAME}.pythonanywhere.com"
PROJECT_DIR="/home/${USERNAME}/profali"
VENV_DIR="/home/${USERNAME}/.virtualenvs/profali"
PA_API_TOKEN="0c19ca39087ba7695d54b502de4167beb55c3b7b"

echo "========================================="
echo "  Prof Ali - PythonAnywhere Setup"
echo "========================================="

# ------------------------------------------
# 1. Find available Python version
# ------------------------------------------
echo ""
echo "[1/9] Finding Python version..."
if command -v python3.10 &> /dev/null; then
    PYTHON_BIN="python3.10"
elif command -v python3.9 &> /dev/null; then
    PYTHON_BIN="python3.9"
elif command -v python3.8 &> /dev/null; then
    PYTHON_BIN="python3.8"
elif command -v python3 &> /dev/null; then
    PYTHON_BIN="python3"
else
    echo "ERROR: No Python 3 found!"
    exit 1
fi
PYTHON_VERSION=$($PYTHON_BIN --version 2>&1)
echo "  Using: $PYTHON_BIN ($PYTHON_VERSION)"

# ------------------------------------------
# 2. Create virtual environment
# ------------------------------------------
echo ""
echo "[2/9] Creating virtual environment..."
if [ -d "$VENV_DIR" ]; then
    echo "  Virtualenv already exists, reusing it."
else
    $PYTHON_BIN -m venv "$VENV_DIR"
    echo "  Created new virtualenv at $VENV_DIR"
fi
source "${VENV_DIR}/bin/activate"
echo "  Activated: $(which python)"

# ------------------------------------------
# 3. Install dependencies
# ------------------------------------------
echo ""
echo "[3/9] Installing Python packages..."
pip install --upgrade pip setuptools wheel 2>&1 | tail -1
pip install django django-crispy-forms crispy-tailwind django-imagekit django-tinymce pillow 2>&1 | tail -1
echo "  Done installing packages."

# ------------------------------------------
# 4. Create media directories
# ------------------------------------------
echo ""
echo "[4/9] Creating media directories..."
mkdir -p "${PROJECT_DIR}/media/services"
mkdir -p "${PROJECT_DIR}/media/testimonies"
mkdir -p "${PROJECT_DIR}/media/blogs"
echo "  Done."

# ------------------------------------------
# 5. Download images
# ------------------------------------------
echo ""
echo "[5/9] Downloading images..."

# Service images
wget -q "https://images.unsplash.com/photo-1509114397022-ed747cca3f65?w=400&h=400&fit=crop" -O "${PROJECT_DIR}/media/services/spiritual_cleansing.jpg" 2>/dev/null || true
wget -q "https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=400&h=400&fit=crop" -O "${PROJECT_DIR}/media/services/love_unity.jpg" 2>/dev/null || true
wget -q "https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=400&h=400&fit=crop" -O "${PROJECT_DIR}/media/services/wealth_abundance.jpg" 2>/dev/null || true
wget -q "https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=400&h=400&fit=crop" -O "${PROJECT_DIR}/media/services/justice.jpg" 2>/dev/null || true
wget -q "https://images.unsplash.com/photo-1471193945509-9ad0617afabf?w=400&h=400&fit=crop" -O "${PROJECT_DIR}/media/services/herbal_healing.jpg" 2>/dev/null || true

# Testimonial avatars
wget -q "https://i.pravatar.cc/256?img=32" -O "${PROJECT_DIR}/media/testimonies/sarah.jpg" 2>/dev/null || true
wget -q "https://i.pravatar.cc/256?img=60" -O "${PROJECT_DIR}/media/testimonies/john.jpg" 2>/dev/null || true
wget -q "https://i.pravatar.cc/256?img=25" -O "${PROJECT_DIR}/media/testimonies/amina.jpg" 2>/dev/null || true

# Blog images
wget -q "https://images.unsplash.com/photo-1471193945509-9ad0617afabf?w=400&h=400&fit=crop" -O "${PROJECT_DIR}/media/blogs/herbs.jpg" 2>/dev/null || true
wget -q "https://images.unsplash.com/photo-1509114397022-ed747cca3f65?w=400&h=400&fit=crop" -O "${PROJECT_DIR}/media/blogs/cleansing.jpg" 2>/dev/null || true

echo "  Done."

# ------------------------------------------
# 6. Run migrations & seed database
# ------------------------------------------
echo ""
echo "[6/9] Running migrations..."
cd "$PROJECT_DIR"
python manage.py migrate --run-syncdb 2>&1 | tail -3
echo "  Done."

echo ""
echo "[6b/9] Seeding database with herbalist data..."
python manage.py shell << 'SEED_EOF'
from rehab.models import Service, Testimony, Blog, Career

Service.objects.all().delete()
Testimony.objects.all().delete()
Blog.objects.all().delete()
Career.objects.all().delete()

Service.objects.create(
    name="Spiritual Cleansing & Protection",
    summary="Remove dark energies, evil spirits, and negative vibrations from your life and home.",
    body="<p>Do you feel weighed down by negative energy? Our spiritual cleansing rituals use sacred herbs and ancestral wisdom to purge darkness and shield you from future harm.</p>",
    image="services/spiritual_cleansing.jpg"
)
Service.objects.create(
    name="Love & Relationship Harmony",
    summary="Bring back lost lovers, fix broken marriages, and attract your soulmate today.",
    body="<p>Love is the foundation of life. Prof Ali provides divine guidance and traditional remedies to restore peace in relationships and reunite separated hearts.</p>",
    image="services/love_unity.jpg"
)
Service.objects.create(
    name="Financial Prosperity & Success",
    summary="Unlock business growth, attract wealth, and enjoy financial luck in all your ventures.",
    body="<p>Are your finances stagnant? Prof Ali offers spiritual keys to unlock prosperity, attract new customers to your business, and clear the path to success.</p>",
    image="services/wealth_abundance.jpg"
)
Service.objects.create(
    name="Court Cases & Legal Support",
    summary="Spiritual guidance and herbal support to ensure favorable outcomes in legal battles.",
    body="<p>Facing a difficult legal situation? Our traditional methods help clear the spiritual hurdles in your path, ensuring justice prevails in your favor.</p>",
    image="services/justice.jpg"
)
Service.objects.create(
    name="Natural Herbal Healing",
    summary="Traditional cures for chronic illnesses and ailments where conventional medicine fails.",
    body="<p>Harnessing the power of pure African herbs, Prof Ali treats a wide range of long-standing physical and spiritual conditions with profound results.</p>",
    image="services/herbal_healing.jpg"
)

Testimony.objects.create(
    name="Sarah Mwangi",
    summary="Financial breakthrough",
    description="I had been struggling with my boutique for three years and was about to close. After a consultation with Prof Ali, my business took a turn I never imagined. Customers are now coming from everywhere!",
    photo="testimonies/sarah.jpg"
)
Testimony.objects.create(
    name="John K.",
    summary="Marriage restored",
    description="My wife had left me for another man and I was devastated. Prof Ali helped me understand the spiritual blockages in our home. Within two weeks, she returned home and we are now closer than ever.",
    photo="testimonies/john.jpg"
)
Testimony.objects.create(
    name="Amina Mohammed",
    summary="Healing success",
    description="My son was suffering from a strange skin condition that no doctor could cure. One visit to Prof Ali and a course of his herbal medicine cleared it up completely in days. A true blessing!",
    photo="testimonies/amina.jpg"
)

Blog.objects.create(
    title="The Secret Power of Sacred Herbs",
    summary="Discover how nature provides everything we need for spiritual and physical wellness.",
    body="<p>Traditional African herbalism is not just about plants; it is about the spirit within them. In this insight, we explore the most powerful herbs for protection and luck.</p>",
    picture="blogs/herbs.jpg"
)
Blog.objects.create(
    title="Signs You Need a Spiritual Cleansing",
    summary="Learn to identify negative energy blockages in your life before they cause harm.",
    body="<p>If you experience constant fatigue, bad luck, or recurring nightmares, your spirit may be under attack. Learn how to cleanse your aura and restore balance.</p>",
    picture="blogs/cleansing.jpg"
)

Career.objects.create(
    title="From Poverty to Prosperity: A Transformation Story",
    summary="See how one man's faith in traditional healing changed his family's legacy forever.",
    description="<p>Moses was a laborer struggling to feed his children. Through Prof Ali's guidance, he identified the spiritual blockages that kept him in poverty. Today, he is a successful landowner and business leader.</p>",
    status="open"
)
Career.objects.create(
    title="The Miracle of Reunited Hearts",
    summary="A deep dive into how spiritual alignment saved a family from the edge of divorce.",
    description="<p>This success story details the journey of a couple who had lost all hope. Through dedicated spiritual work and marital guidance under Prof Ali, their home was restored to peace and love.</p>",
    status="open"
)

print("Database seeded successfully!")
SEED_EOF

echo "  Done."

# ------------------------------------------
# 7. Collect static files
# ------------------------------------------
echo ""
echo "[7/9] Collecting static files..."
python manage.py collectstatic --noinput 2>&1 | tail -1
echo "  Done."

# ------------------------------------------
# 8. Create superuser
# ------------------------------------------
echo ""
echo "[8/9] Creating admin superuser..."
python manage.py shell << 'ADMIN_EOF'
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'info@profali.com', 'profali2024')
    print("Superuser 'admin' created with password 'profali2024'")
else:
    print("Superuser 'admin' already exists.")
ADMIN_EOF
echo "  Done."

# ------------------------------------------
# 9. Create Web App via API & configure WSGI
# ------------------------------------------
echo ""
echo "[9/9] Creating web app via PythonAnywhere API..."

# Extract just the version number (e.g. "3.10")
PY_VER=$($PYTHON_BIN -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")

# Create the web app
curl -s -X POST \
  -H "Authorization: Token ${PA_API_TOKEN}" \
  -d "domain_name=${DOMAIN}&python_version=${PY_VER}" \
  "https://www.pythonanywhere.com/api/v0/user/${USERNAME}/webapps/" > /tmp/webapp_result.json 2>&1

cat /tmp/webapp_result.json
echo ""

# Write WSGI file
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
echo "  WSGI file written to $WSGI_FILE"

# Configure virtualenv path
curl -s -X PATCH \
  -H "Authorization: Token ${PA_API_TOKEN}" \
  -d "virtualenv_path=${VENV_DIR}" \
  "https://www.pythonanywhere.com/api/v0/user/${USERNAME}/webapps/${DOMAIN}/" > /dev/null 2>&1

# Configure source directory
curl -s -X PATCH \
  -H "Authorization: Token ${PA_API_TOKEN}" \
  -d "source_directory=${PROJECT_DIR}" \
  "https://www.pythonanywhere.com/api/v0/user/${USERNAME}/webapps/${DOMAIN}/" > /dev/null 2>&1

# Add static files mapping
curl -s -X POST \
  -H "Authorization: Token ${PA_API_TOKEN}" \
  -d "url=/static/&path=${PROJECT_DIR}/staticfiles" \
  "https://www.pythonanywhere.com/api/v0/user/${USERNAME}/webapps/${DOMAIN}/static_files/" > /dev/null 2>&1

# Add media files mapping
curl -s -X POST \
  -H "Authorization: Token ${PA_API_TOKEN}" \
  -d "url=/media/&path=${PROJECT_DIR}/media" \
  "https://www.pythonanywhere.com/api/v0/user/${USERNAME}/webapps/${DOMAIN}/static_files/" > /dev/null 2>&1

# Reload the web app
curl -s -X POST \
  -H "Authorization: Token ${PA_API_TOKEN}" \
  "https://www.pythonanywhere.com/api/v0/user/${USERNAME}/webapps/${DOMAIN}/reload/" > /dev/null 2>&1

echo "  Web app configured and reloaded!"

# ------------------------------------------
# Final Summary
# ------------------------------------------
echo ""
echo "========================================="
echo "  SETUP COMPLETE!"
echo "========================================="
echo ""
echo "  Live site:  https://${DOMAIN}"
echo "  Admin:      https://${DOMAIN}/admin/"
echo "  Username:   admin"
echo "  Password:   profali2024"
echo ""
echo "  If the site does not load, go to the"
echo "  Web tab and click Reload."
echo "========================================="
